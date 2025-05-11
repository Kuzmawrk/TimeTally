import Foundation

class Persistence {
    static let shared = Persistence()
    
    private init() {}
    
    func saveTimeEntries(_ entries: [TimeEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.timeEntries)
        }
    }
    
    func loadTimeEntries() -> [TimeEntry] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.timeEntries),
              let entries = try? JSONDecoder().decode([TimeEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    func saveOnboardingCompleted() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasCompletedOnboarding)
    }
    
    func hasCompletedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasCompletedOnboarding)
    }
}
