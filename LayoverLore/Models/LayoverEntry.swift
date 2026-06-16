
import Foundation
import SwiftData

@Model
final class LayoverEntry {
    var id: UUID
    var cityName: String
    var routeTitle: String
    var date: Date
    var photoData: Data?
    var durationMinutes: Int
    var airportCode: String

    init(
        id: UUID = UUID(),
        cityName: String,
        routeTitle: String,
        date: Date,
        photoData: Data? = nil,
        durationMinutes: Int,
        airportCode: String
    ) {
        self.id = id
        self.cityName = cityName
        self.routeTitle = routeTitle
        self.date = date
        self.photoData = photoData
        self.durationMinutes = durationMinutes
        self.airportCode = airportCode
    }
}
