import Foundation

struct CategoryStat: Identifiable {
    let id: UUID
    let category: TimeEntry.Category
    let total: Double
    
    init(category: TimeEntry.Category, total: Double) {
        self.id = UUID()
        self.category = category
        self.total = total
    }
}