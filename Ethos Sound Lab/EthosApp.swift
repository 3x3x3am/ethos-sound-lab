import SwiftUI

@main
struct EthosApp: App {
    @StateObject private var store = ProjectStore()
    var body: some Scene {
        WindowGroup {
            StudioView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
