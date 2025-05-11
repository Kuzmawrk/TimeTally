import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = !Persistence.shared.hasCompletedOnboarding()
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                MainTabView()
            }
        }
    }
}
