import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: TimeEntriesViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ttBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        weeklyStatsCard
                        monthlyStatsCard
                        categoryDistributionCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistics")
        }
    }
    
    private var weeklyStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Overview")
                .font(.headline)
                .foregroundColor(Color(.ttText))
            
            VStack(spacing: 12) {
                StatRow(title: "This Week", 
                       value: String(format: "%.1f", viewModel.weeklyTotal()),
                       unit: "hours",
                       color: Color(.ttPrimary))
                
                StatRow(title: "Daily Average", 
                       value: String(format: "%.1f", viewModel.weeklyTotal() / 7),
                       unit: "hours",
                       color: Color(.ttSecondary))
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var monthlyStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Overview")
                .font(.headline)
                .foregroundColor(Color(.ttText))
            
            VStack(spacing: 12) {
                StatRow(title: "This Month", 
                       value: String(format: "%.1f", viewModel.monthlyTotal()),
                       unit: "hours",
                       color: Color(.ttPrimary))
                
                StatRow(title: "Daily Average", 
                       value: String(format: "%.1f", viewModel.monthlyTotal() / 30),
                       unit: "hours",
                       color: Color(.ttSecondary))
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var categoryDistributionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Distribution")
                .font(.headline)
                .foregroundColor(Color(.ttText))
            
            VStack(spacing: 12) {
                ForEach(viewModel.categoryBreakdown(), id: \\.category) { item in
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
                }
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color(.ttText))
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(Color(.ttText))
            }
        }
    }
}