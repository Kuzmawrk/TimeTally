import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: TimeEntriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var duration = ""
    @State private var category = TimeEntry.Category.work
    
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
                        Text("New Time Entry")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
        
        let entry = TimeEntry(
            title: title,
            duration: durationValue,
            category: category
        )
        
        viewModel.addEntry(entry)
        clearFields()
        dismiss() // Dismiss view after saving
    }
    
    private func clearFields() {
        title = ""
        duration = ""
        category = .work
    }
}
