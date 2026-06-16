
import SwiftUI

struct RouteListScreen: View {
    @State private var viewModel: RouteListViewModel
    @Binding private var path: [AppRoute]

    init(city: City, availableMinutes: Int, path: Binding<[AppRoute]>) {
        _viewModel = State(initialValue: RouteListViewModel(city: city, availableMinutes: availableMinutes))
        _path = path
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Picker("Max duration", selection: $viewModel.durationFilter) {
                    ForEach(RouteListViewModel.DurationFilter.allCases) { filter in
                        Text(filter.label).tag(filter.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)

                if viewModel.filteredRoutes.isEmpty {
                    ContentUnavailableView(
                        "No routes in this range",
                        systemImage: "map",
                        description: Text("Try a longer duration filter.")
                    )
                    .padding(.top, 40)
                } else {
                    ForEach(viewModel.filteredRoutes) { route in
                        Button {
                            path.append(.routeDetail(
                                route: route,
                                city: viewModel.city,
                                windowMinutes: min(route.durationMinutes, viewModel.availableMinutes)
                            ))
                        } label: {
                            RouteCard(route: route, exceedsWindow: viewModel.exceedsWindow(route))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RouteCard: View {
    let route: Route
    let exceedsWindow: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))

            VStack(alignment: .leading, spacing: 12) {
                Text(route.title)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.leading)

                HStack(spacing: 16) {
                    Label(route.durationText, systemImage: "clock")
                    Label(route.distanceText, systemImage: "figure.walk")
                    Label("\(route.attractions.count) stops", systemImage: "mappin.and.ellipse")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                if exceedsWindow {
                    Label("Longer than your window", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
