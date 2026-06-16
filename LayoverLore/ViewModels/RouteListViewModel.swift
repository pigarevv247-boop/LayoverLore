
import Foundation

@Observable
final class RouteListViewModel {
    let city: City
    let availableMinutes: Int

    var durationFilter: Int = DurationFilter.fourHours.rawValue

    enum DurationFilter: Int, CaseIterable, Identifiable {
        case twoHours = 120
        case fourHours = 240
        case sixHours = 360

        var id: Int { rawValue }
        var label: String {
            switch self {
            case .twoHours: return "2 h"
            case .fourHours: return "4 h"
            case .sixHours: return "6 h"
            }
        }
    }

    init(city: City, availableMinutes: Int) {
        self.city = city
        self.availableMinutes = availableMinutes
    }

    var filteredRoutes: [Route] {
        city.routes
            .filter { $0.durationMinutes <= durationFilter }
            .sorted { $0.durationMinutes < $1.durationMinutes }
    }

    func exceedsWindow(_ route: Route) -> Bool {
        route.durationMinutes > availableMinutes
    }
}
