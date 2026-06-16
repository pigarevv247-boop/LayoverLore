
import SwiftUI
import SwiftData

struct DiaryScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LayoverEntry.date, order: .reverse) private var entries: [LayoverEntry]

    @State private var selectedEntry: LayoverEntry?

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No layovers yet",
                    systemImage: "book.closed",
                    description: Text("Save a route from a city walk and it will appear here.")
                )
            } else {
                List {
                    ForEach(entries) { entry in
                        Button {
                            selectedEntry = entry
                        } label: {
                            DiaryRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationTitle("My diary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !entries.isEmpty {
                ToolbarItem(placement: .topBarTrailing) { EditButton() }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            DiaryEntryDetailView(entry: entry)
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
        try? modelContext.save()
    }
}

struct DiaryRow: View {
    let entry: LayoverEntry

    var body: some View {
        HStack(spacing: 14) {
            thumbnail
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.cityName)
                    .font(.headline)
                Text(entry.routeTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = entry.photoData, let image = UIImage(data: data) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            Rectangle()
                .fill(Color(.tertiarySystemFill))
                .overlay(Image(systemName: "airplane").foregroundStyle(.secondary))
        }
    }
}

struct DiaryEntryDetailView: View {
    let entry: LayoverEntry
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let data = entry.photoData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.cityName)
                            .font(.largeTitle.bold())
                        Label(entry.routeTitle, systemImage: "map")
                        Label(entry.date.formatted(date: .complete, time: .shortened), systemImage: "calendar")
                        Label("Duration: \(entry.durationMinutes.asHoursMinutes)", systemImage: "clock")
                        Label("Airport: \(entry.airportCode)", systemImage: "airplane")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle(entry.cityName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
