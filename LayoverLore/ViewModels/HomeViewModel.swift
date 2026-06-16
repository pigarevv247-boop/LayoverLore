
import Foundation

@Observable
final class HomeViewModel {
    var flightDepartureTime: Date = Date().addingTimeInterval(5 * 3600)

    var bufferMinutes: Int = 90

    let bufferOptions = [60, 90, 120]

    var availableMinutes: Int {
        let secondsUntilDeparture = flightDepartureTime.timeIntervalSinceNow
        let usable = secondsUntilDeparture - Double(bufferMinutes * 60)
        return max(0, Int(usable / 60))
    }

    var windowText: String {
        availableMinutes <= 0
            ? "No time for a city walk — keep your buffer."
            : "Your window: \(availableMinutes.asHoursMinutes)"
    }

    var hasUsableWindow: Bool { availableMinutes >= 60 }
}
