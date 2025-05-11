import Foundation
import SwiftUI

@MainActor
class TimeEntriesViewModel: ObservableObject {
    @Published var timeEntries: [TimeEntry] = []
    @Published var showingSuccessNotification = false
    
    init() {
        timeEntries = Persistence.shared.loadTimeEntries()
    }
    
    func addEntry(_ entry: TimeEntry) {
        timeEntries.append(entry)
        saveEntries()
        showSuccessNotification()
    }
    
    func updateEntry(_ entry: TimeEntry) {
        if let index = timeEntries.firstIndex(where: { $0.id == entry.id }) {
            timeEntries[index] = entry
            saveEntries()
            showSuccessNotification()
        }
    }
    
    func deleteEntry(_ entry: TimeEntry) {
        timeEntries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func shareEntry(_ entry: TimeEntry) -> String {
        "I spent \(String(format: "%.1f", entry.duration)) hours on \(entry.title) (\(entry.category.rawValue)) using TimeTally!"
    }
    
    private func saveEntries() {
        Persistence.shared.saveTimeEntries(timeEntries)
    }
    
    private func showSuccessNotification() {
        showingSuccessNotification = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showingSuccessNotification = false
        }
    }
    
    // MARK: - Statistics
    
    func dailyTotal(for date: Date) -> Double {
        timeEntries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { $0 + $1.duration }
    }
    
    func weeklyTotal() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(byAdding: .day, value: -6, to: now)!
        
        return timeEntries
            .filter { $0.date >= startOfWeek }
            .reduce(0) { $0 + $1.duration }
    }
    
    func monthlyTotal() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(byAdding: .day, value: -29, to: now)!
        
        return timeEntries
            .filter { $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.duration }
    }
    
    func categoryBreakdown() -> [(category: TimeEntry.Category, total: Double)] {
        Dictionary(grouping: timeEntries, by: { $0.category })
            .map { (category: $0.key, total: $0.value.reduce(0) { $0 + $1.duration }) }
            .sorted { $0.total > $1.total }
    }
}
