import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TimeEntriesViewModel()
    @State private var selectedTab = 0
    @State private var showingAddEntry = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab, showingAddEntry: $showingAddEntry)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(Color(.ttPrimary))
        .sheet(isPresented: $showingAddEntry) {
            AddEntryView(viewModel: viewModel)
        }
        .onAppear {
            // Set tab bar appearance for both light and dark modes
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
    }
}
