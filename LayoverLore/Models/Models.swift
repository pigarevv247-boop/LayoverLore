
import Foundation
import CoreLocation


struct City: Identifiable, Hashable {
    let id: UUID
    let name: String
    let country: String
    let airportCode: String
    let previewImageName: String
    let routes: [Route]

    init(
        id: UUID = UUID(),
        name: String,
        country: String,
        airportCode: String,
        previewImageName: String,
        routes: [Route]
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.airportCode = airportCode
        self.previewImageName = previewImageName
        self.routes = routes
    }
}


struct Route: Identifiable, Hashable {
    let id: UUID
    let title: String
    let durationMinutes: Int
    let totalDistanceMeters: Double
    let attractions: [Attraction]
    let tips: [Tip]

    init(
        id: UUID = UUID(),
        title: String,
        durationMinutes: Int,
        totalDistanceMeters: Double,
        attractions: [Attraction],
        tips: [Tip]
    ) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.totalDistanceMeters = totalDistanceMeters
        self.attractions = attractions
        self.tips = tips
    }

    var distanceText: String {
        let km = totalDistanceMeters / 1000
        return String(format: "%.1f km", km)
    }

    var durationText: String {
        durationMinutes.asHoursMinutes
    }
}


struct Attraction: Identifiable, Hashable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    let timeOnSiteMinutes: Int
    let travelToNextMinutes: Int
    let description: String

    init(
        id: UUID = UUID(),
        name: String,
        coordinate: CLLocationCoordinate2D,
        timeOnSiteMinutes: Int,
        travelToNextMinutes: Int,
        description: String
    ) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.timeOnSiteMinutes = timeOnSiteMinutes
        self.travelToNextMinutes = travelToNextMinutes
        self.description = description
    }
}


struct Tip: Identifiable, Hashable {
    let id: UUID
    let icon: String
    let text: String
    let category: TipCategory

    init(id: UUID = UUID(), icon: String, text: String, category: TipCategory) {
        self.id = id
        self.icon = icon
        self.text = text
        self.category = category
    }
}

enum TipCategory: String, CaseIterable {
    case transport, visa, packing, timing

    var title: String {
        switch self {
        case .transport: return "Transport"
        case .visa: return "Visa"
        case .packing: return "Packing"
        case .timing: return "Timing"
        }
    }
}


extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}


extension Int {
    var asHoursMinutes: String {
        let hours = self / 60
        let minutes = self % 60
        switch (hours, minutes) {
        case (0, _): return "\(minutes) min"
        case (_, 0): return "\(hours) h"
        default: return "\(hours) h \(minutes) min"
        }
    }
}
