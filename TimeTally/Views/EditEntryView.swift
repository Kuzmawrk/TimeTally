import SwiftUI

struct EditEntryView: View {
    let entry: TimeEntry
    @ObservedObject var viewModel: TimeEntriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var duration: String
    @State private var category: TimeEntry.Category
    
    init(entry: TimeEntry, viewModel: TimeEntriesViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _title = State(initialValue: entry.title)
        _duration = State(initialValue: String(format: "%.1f", entry.duration))
        _category = State(initialValue: entry.category)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ttBackground)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Activity Title", text: $title)
                            .textContentType(.none)
                            .autocorrectionDisabled()
                        
                        TextField("Duration (hours)", text: $duration)
                            .keyboardType(.decimalPad)
                            .onChange(of: duration) { newValue in
                                if let lastChar = newValue.last, lastChar == "," {
                                    duration = newValue.replacingOccurrences(of: ",", with: ".")
                                }
                            }
                        
                        Picker("Category", selection: $category) {
                            ForEach(TimeEntry.Category.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                    .tag(category)
                            }
                        }
                    } header: {
                        Text("Edit Time Entry")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty || duration.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        // Convert comma to period for decimal parsing
        let normalizedDuration = duration.replacingOccurrences(of: ",", with: ".")
        guard let durationValue = Double(normalizedDuration) else { return }
        
        let updatedEntry = TimeEntry(
            id: entry.id,
            title: title,
            duration: durationValue,
            category: category,
            date: entry.date
        )
        
        viewModel.updateEntry(updatedEntry)
        dismiss()
    }
}
