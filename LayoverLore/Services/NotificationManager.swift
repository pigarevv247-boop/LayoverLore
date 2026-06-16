
import Foundation
import UserNotifications

@Observable
final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let reminderIdentifier = "layover.return.reminder"

    private(set) var isAuthorized = false

    private init() {}

    func requestAuthorization() async {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run { self.isAuthorized = granted }
        } catch {
            await MainActor.run { self.isAuthorized = false }
        }
    }

    func scheduleReturnReminder(after minutes: Int, airportCode: String) async {
        if !isAuthorized { await requestAuthorization() }
        guard isAuthorized else { return }

        cancelReturnReminder()

        let content = UNMutableNotificationContent()
        content.title = "Time to head back"
        content.body = "Your safe window is closing — start making your way back to \(airportCode)."
        content.sound = .default

        let interval = max(60, TimeInterval(minutes * 60))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: reminderIdentifier, content: content, trigger: trigger)

        try? await center.add(request)
    }

    func cancelReturnReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
    }
}
