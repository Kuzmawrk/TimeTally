import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    let pages = [
        OnboardingPage(image: "clock.fill",
                       title: "Track Your Time",
                       description: "Log your daily activities and see where your time goes"),
        OnboardingPage(image: "chart.pie.fill",
                       title: "Analyze & Improve",
                       description: "Get insights with daily and weekly summaries"),
        OnboardingPage(image: "star.fill",
                       title: "Stay Productive",
                       description: "Optimize your time and achieve more every day")
    ]
    
    func completeOnboarding() {
        Persistence.shared.saveOnboardingCompleted()
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}
