import SwiftUI

struct EntryDetailView: View {
    let entry: TimeEntry
    @ObservedObject var viewModel: TimeEntriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(.ttBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                detailCard
                actionButtons
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            EditEntryView(entry: entry, viewModel: viewModel)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this entry?")
        }
    }
    
    private var detailCard: some View {
        VStack(spacing: 16) {
            Text(entry.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(.ttText))
            
            HStack(spacing: 24) {
                DetailItem(title: "Duration",
                          value: String(format: "%.1f hrs", entry.duration),
                          color: Color(.ttPrimary))
                
                DetailItem(title: "Category",
                          value: entry.category.rawValue,
                          color: Color(entry.category.color))
                
                DetailItem(title: "Date",
                          value: entry.date.formatted(date: .abbreviated, time: .omitted),
                          color: Color(.ttSecondary))
            }
        }
        .padding()
        .background(Color(.ttBackground))
        .cornerRadius(16)
        .shadow(radius: 8)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            ActionButton(title: "Edit", icon: "pencil", color: Color(.ttPrimary)) {
                showingEditSheet = true
            }
            
            ActionButton(title: "Delete", icon: "trash", color: .red) {
                showingDeleteAlert = true
            }
            
            ActionButton(title: "Share", icon: "square.and.arrow.up", color: Color(.ttSecondary)) {
                shareEntry()
            }
        }
    }
    
    private func deleteEntry() {
        viewModel.deleteEntry(entry)
        dismiss()
    }
    
    private func shareEntry() {
        let text = viewModel.shareEntry(entry)
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct DetailItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.ttText))
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}
