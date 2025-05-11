import Foundation

struct TimeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var duration: Double
    var category: Category
    var date: Date
    
    init(id: UUID = UUID(), title: String, duration: Double, category: Category, date: Date = Date()) {
        self.id = id
        self.title = title
        self.duration = duration
        self.category = category
        self.date = date
    }
    
    enum Category: String, Codable, CaseIterable {
        case work = "Work"
        case rest = "Rest"
        case personal = "Personal"
        
        var color: String {
            switch self {
            case .work: return "ttPrimary"
            case .rest: return "ttSecondary"
            case .personal: return "ttText"
            }
        }
    }
}
