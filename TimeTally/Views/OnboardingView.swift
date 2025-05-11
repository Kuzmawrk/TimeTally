import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            Color(.ttBackground)
                .ignoresSafeArea()
            
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    OnboardingPageView(page: viewModel.pages[index],
                                     isLastPage: index == viewModel.pages.count - 1,
                                     currentPage: $viewModel.currentPage,
                                     onComplete: completeOnboarding)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
    
    private func completeOnboarding() {
        viewModel.completeOnboarding()
        showOnboarding = false
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    @Binding var currentPage: Int
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80))
                .foregroundColor(Color(.ttPrimary))
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.ttText))
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.ttText))
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            if isLastPage {
                Button(action: onComplete) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(.ttPrimary))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
            } else {
                Button {
                    withAnimation {
                        currentPage += 1
                    }
                } label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(.ttPrimary))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
                .frame(height: 50)
        }
    }
}
