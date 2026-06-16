
import SwiftUI
import SwiftData

@main
struct LayoverLoreApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: LayoverEntry.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
        .modelContainer(modelContainer)
    }
}
