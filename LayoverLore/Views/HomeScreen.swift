
import SwiftUI

struct HomeScreen: View {
    @State private var viewModel = HomeViewModel()
    @State private var path: [AppRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 28) {
                    header

                    departureCard

                    bufferCard

                    windowCard

                    actionButtons
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("LayoverLore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(.diary)
                    } label: {
                        Image(systemName: "book.closed")
                    }
                    .accessibilityLabel("Open diary")
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
    }


    private var header: some View {
        VStack(spacing: 6) {
            Text("LayoverLore")
                .font(.largeTitle.bold())
            Text("Turn your layover into a story worth telling.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var departureCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                Label("Flight departure", systemImage: "airplane.departure")
                    .font(.headline)
                DatePicker(
                    "Departure time",
                    selection: $viewModel.flightDepartureTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
            }
        }
    }

    private var bufferCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 12) {
                Label("Airport buffer", systemImage: "clock.badge.exclamationmark")
                    .font(.headline)
                Text("Time kept aside before departure for security and boarding.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Buffer", selection: $viewModel.bufferMinutes) {
                    ForEach(viewModel.bufferOptions, id: \.self) { option in
                        Text("\(option) min").tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var windowCard: some View {
        CardContainer {
            HStack(spacing: 14) {
                Image(systemName: viewModel.hasUsableWindow ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.title)
                    .foregroundStyle(viewModel.hasUsableWindow ? .green : .orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.windowText)
                        .font(.title3.weight(.semibold))
                    Text("Based on your departure and buffer.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                path.append(.citySelection(availableMinutes: viewModel.availableMinutes))
            } label: {
                Label("Find routes", systemImage: "map")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.hasUsableWindow)

            Button {
                path.append(.diary)
            } label: {
                Label("My diary", systemImage: "book.closed")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }


    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case let .citySelection(minutes):
            CitySelectionScreen(availableMinutes: minutes, path: $path)
        case let .routeList(city, minutes):
            RouteListScreen(city: city, availableMinutes: minutes, path: $path)
        case let .routeDetail(r, city, window):
            RouteDetailScreen(route: r, city: city, windowMinutes: window)
        case .diary:
            DiaryScreen()
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: LayoverEntry.self, inMemory: true)
}
