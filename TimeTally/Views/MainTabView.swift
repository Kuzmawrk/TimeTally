import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TimeEntriesViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AddEntryView(viewModel: viewModel)
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(Color(.ttPrimary))
    }
}
