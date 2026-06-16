
import Foundation
import MapKit
import SwiftData

@Observable
final class RouteDetailViewModel {
    struct NumberedAttraction: Identifiable, Hashable {
        let index: Int
        let attraction: Attraction

        var id: UUID { attraction.id }
    }

    let route: Route
    let city: City
    let windowMinutes: Int

    let mapRegion: MKCoordinateRegion

    var remainingSeconds: Int
    var isTimerRunning = false

    init(route: Route, city: City, windowMinutes: Int) {
        self.route = route
        self.city = city
        self.windowMinutes = windowMinutes
        self.remainingSeconds = windowMinutes * 60
        self.mapRegion = Self.region(for: route.attractions)
    }

    var numberedAttractions: [NumberedAttraction] {
        route.attractions.enumerated().map {
            NumberedAttraction(index: $0.offset + 1, attraction: $0.element)
        }
    }

    var countdownText: String {
        let clamped = max(0, remainingSeconds)
        let h = clamped / 3600
        let m = (clamped % 3600) / 60
        let s = clamped % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }

    var isCountdownCritical: Bool { remainingSeconds <= 15 * 60 }

    func startTimer() async {
        isTimerRunning = true
        remainingSeconds = windowMinutes * 60
        await NotificationManager.shared.scheduleReturnReminder(
            after: windowMinutes,
            airportCode: city.airportCode
        )
    }

    func tick() {
        guard isTimerRunning, remainingSeconds > 0 else { return }
        remainingSeconds -= 1
        if remainingSeconds == 0 { isTimerRunning = false }
    }

    func saveToDiary(photoData: Data?, context: ModelContext) {
        let entry = LayoverEntry(
            cityName: city.name,
            routeTitle: route.title,
            date: .now,
            photoData: photoData,
            durationMinutes: route.durationMinutes,
            airportCode: city.airportCode
        )
        context.insert(entry)
        try? context.save()
    }


    private static func region(for attractions: [Attraction]) -> MKCoordinateRegion {
        guard let first = attractions.first else {
            return MKCoordinateRegion(
                center: .init(latitude: 0, longitude: 0),
                span: .init(latitudeDelta: 1, longitudeDelta: 1)
            )
        }
        var minLat = first.coordinate.latitude, maxLat = first.coordinate.latitude
        var minLon = first.coordinate.longitude, maxLon = first.coordinate.longitude
        for a in attractions {
            minLat = min(minLat, a.coordinate.latitude)
            maxLat = max(maxLat, a.coordinate.latitude)
            minLon = min(minLon, a.coordinate.longitude)
            maxLon = max(maxLon, a.coordinate.longitude)
        }
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.6),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.6)
        )
        return MKCoordinateRegion(center: center, span: span)
    }
}
