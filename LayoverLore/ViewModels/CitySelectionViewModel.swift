
import Foundation

@Observable
final class CitySelectionViewModel {
    let availableMinutes: Int
    let cities: [City]

    init(availableMinutes: Int, cities: [City] = SampleData.cities) {
        self.availableMinutes = availableMinutes
        self.cities = cities
    }

    var windowLabel: String {
        "Available window: \(availableMinutes.asHoursMinutes)"
    }
}
