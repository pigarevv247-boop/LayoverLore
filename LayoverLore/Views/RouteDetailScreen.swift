
import SwiftUI
import MapKit
import PhotosUI

struct RouteDetailScreen: View {
    @State private var viewModel: RouteDetailViewModel
    @State private var mapRegion: MKCoordinateRegion
    @Environment(\.modelContext) private var modelContext

    @State private var showSavePhotoSheet = false
    @State private var savedConfirmation = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(route: Route, city: City, windowMinutes: Int) {
        let viewModel = RouteDetailViewModel(route: route, city: city, windowMinutes: windowMinutes)
        _viewModel = State(initialValue: viewModel)
        _mapRegion = State(initialValue: viewModel.mapRegion)
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                map
                    .frame(height: proxy.size.height * 0.45)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.route.title)
                            .font(.title2.bold())

                        countdownSection

                        itinerarySection

                        tipsSection

                        saveButton
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(ticker) { _ in viewModel.tick() }
        .sheet(isPresented: $showSavePhotoSheet) {
            SaveToDiarySheet { photoData in
                viewModel.saveToDiary(photoData: photoData, context: modelContext)
                savedConfirmation = true
            }
        }
        .alert("Saved to diary", isPresented: $savedConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This layover is now in your diary.")
        }
    }


    private var map: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: viewModel.numberedAttractions) { item in
            MapAnnotation(coordinate: item.attraction.coordinate) {
                    NumberedPin(number: item.index)
            }
        }
    }


    private var countdownSection: some View {
        CardContainer {
            VStack(spacing: 12) {
                CountdownTimerView(
                    text: viewModel.countdownText,
                    isCritical: viewModel.isCountdownCritical && viewModel.isTimerRunning
                )
                Button {
                    Task { await viewModel.startTimer() }
                } label: {
                    Label(viewModel.isTimerRunning ? "Timer running" : "Start timer", systemImage: "timer")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isTimerRunning)

                Text("We'll send a reminder when it's time to head back to \(viewModel.city.airportCode).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }


    private var itinerarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Itinerary")
                .font(.headline)

            ForEach(viewModel.numberedAttractions, id: \.attraction.id) { item in
                CardContainer {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            NumberBadge(number: item.index)
                            Text(item.attraction.name)
                                .font(.headline)
                        }
                        Text(item.attraction.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            Label("\(item.attraction.timeOnSiteMinutes) min here", systemImage: "mappin")
                            if item.attraction.travelToNextMinutes > 0 {
                                Label("\(item.attraction.travelToNextMinutes) min to next", systemImage: "arrow.right")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }


    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tips")
                .font(.headline)
            CardContainer {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.route.tips) { tip in
                        TipCardView(tip: tip)
                        if tip.id != viewModel.route.tips.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var saveButton: some View {
        Button {
            showSavePhotoSheet = true
        } label: {
            Label("Save to diary", systemImage: "book.closed")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .padding(.top, 4)
    }
}


struct CountdownTimerView: View {
    let text: String
    let isCritical: Bool

    var body: some View {
        Text(text)
            .font(.system(size: 44, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(isCritical ? .red : .primary)
            .contentTransition(.numericText())
            .animation(.default, value: text)
    }
}

struct NumberBadge: View {
    let number: Int
    var body: some View {
        Text("\(number)")
            .font(.footnote.bold())
            .foregroundStyle(.white)
            .frame(width: 24, height: 24)
            .background(Color.accentColor)
            .clipShape(Circle())
    }
}


private struct SaveToDiarySheet: View {
    let onSave: (Data?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Add a photo from your walk (optional) and save this layover to your diary.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Group {
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.badge.plus").font(.largeTitle)
                                    Text("No photo selected").font(.caption)
                                }
                                .foregroundStyle(.secondary)
                            )
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Choose photo", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Spacer()

                Button {
                    onSave(imageData)
                    dismiss()
                } label: {
                    Label("Save layover", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .navigationTitle("Save to diary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
        }
    }
}
