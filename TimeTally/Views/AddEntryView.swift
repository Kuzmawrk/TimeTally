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
        guard let durationValue = Double(duration) else { return }
        
        let entry = TimeEntry(
            title: title,
            duration: durationValue,
            category: category
        )
        
        viewModel.addEntry(entry)
        clearFields()
    }
    
    private func clearFields() {
        title = ""
        duration = ""
        category = .work
    }
}
