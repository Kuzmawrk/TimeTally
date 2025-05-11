import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TimeEntriesViewModel
    @Binding var selectedTab: Int
    @Binding var showingAddEntry: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ttBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        summaryCards
                        timeEntriesList
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddEntry = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(.ttPrimary))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("TimeTally")
            .overlay(successNotification)
        }
    }
    
    private var summaryCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(title: "Today",
                         value: String(format: "%.1f", viewModel.dailyTotal(for: Date())),
                         unit: "hours",
                         color: Color(.ttPrimary))
                
                StatCard(title: "This Week",
                         value: String(format: "%.1f", viewModel.weeklyTotal()),
                         unit: "hours",
                         color: Color(.ttSecondary))
            }
            
            categoryBreakdown
        }
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category Breakdown")
                .font(.headline)
                .foregroundColor(Color(.ttText))
            
            ForEach(viewModel.categoryBreakdown(), id: \.category) { item in
                HStack {
                    Circle()
                        .fill(Color(item.category.color))
                        .frame(width: 12, height: 12)
                    
                    Text(item.category.rawValue)
                        .foregroundColor(Color(.ttText))
                    
                    Spacer()
                    
                    Text(String(format: "%.1f hrs", item.total))
                        .foregroundColor(Color(.ttText))
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var timeEntriesList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.timeEntries.sorted(by: { $0.date > $1.date })) { entry in
                NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                    TimeEntryCard(entry: entry)
                }
            }
        }
    }
    
    private var successNotification: some View {
        Group {
            if viewModel.showingSuccessNotification {
                VStack {
                    Spacer()
                    Text("Entry saved successfully!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(.ttPrimary))
                        .cornerRadius(8)
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: viewModel.showingSuccessNotification)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color(.ttText))
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(Color(.ttText))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct TimeEntryCard: View {
    let entry: TimeEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(Color(.ttText))
                
                Text(entry.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(Color(entry.category.color))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f hrs", entry.duration))
                    .font(.headline)
                    .foregroundColor(Color(.ttText))
                
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(Color(.ttText))
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
