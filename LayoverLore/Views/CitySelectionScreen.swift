
import SwiftUI

struct CitySelectionScreen: View {
    @State private var viewModel: CitySelectionViewModel
    @Binding private var path: [AppRoute]

    init(availableMinutes: Int, path: Binding<[AppRoute]>) {
        _viewModel = State(initialValue: CitySelectionViewModel(availableMinutes: availableMinutes))
        _path = path
    }

    var body: some View {
        List {
            Section {
                ForEach(viewModel.cities) { city in
                    Button {
                        open(city)
                    } label: {
                        CityRow(city: city)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Label(viewModel.windowLabel, systemImage: "clock")
                    .font(.subheadline)
                    .textCase(nil)
                    .foregroundStyle(.primary)
            }
        }
        .navigationTitle("Choose a city")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func open(_ city: City) {
        path.append(.routeList(city: city, availableMinutes: viewModel.availableMinutes))
    }
}

struct CityRow: View {
    let city: City

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: city.previewImageName)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle().fill(Color(.tertiarySystemFill))
                        .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(city.name)
                    .font(.headline)
                Text("\(city.country) · \(city.airportCode)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
