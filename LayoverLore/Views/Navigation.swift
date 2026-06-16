
import Foundation

enum AppRoute: Hashable {
    case citySelection(availableMinutes: Int)
    case routeList(city: City, availableMinutes: Int)
    case routeDetail(route: Route, city: City, windowMinutes: Int)
    case diary
}
