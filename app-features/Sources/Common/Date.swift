import Foundation

public extension Date {
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    var endOfPreviousDay: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self.endOfDay)!
    }

    var roundedToHours: Date {
        Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: self), minute: 0, second: 0, of: self)!
    }
}
