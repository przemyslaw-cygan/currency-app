import Foundation

public enum DetailsDateRange: String, Hashable, Sendable {
    case week
    case month
    case year

    public var label: String? {
        switch self {
        case .week:
            "Week"
        case .month:
            "Month"
        case .year:
            "Year"
        }
    }

    public func dates(for date: Date) throws -> (start: Date, end: Date) {
        let (component, value): (Calendar.Component, Int) = switch self {
        case .week:
            (.weekOfYear, -1)
        case .month:
            (.month, -1)
        case .year:
            (.year, -1)
        }

        let calendar = Calendar(identifier: .iso8601)
        guard let start = calendar.date(byAdding: component, value: value, to: date) else {
            throw URLError(.unknown)
        }

        return (
            start: start,
            end: date
        )
    }
}
