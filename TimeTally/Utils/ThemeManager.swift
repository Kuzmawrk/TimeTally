import SwiftUI

@MainActor
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: UserDefaultsKeys.isDarkMode)
            updateAppTheme()
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isDarkMode)
        updateAppTheme()
    }
    
    private func updateAppTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
}