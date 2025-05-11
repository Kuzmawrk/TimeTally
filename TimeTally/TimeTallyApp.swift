import SwiftUI
import Extension

@main
struct TimeTallyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
                    .environmentObject(themeManager)
            }
        }
    }
}