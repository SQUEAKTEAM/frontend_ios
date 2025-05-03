//
//  CalendarPresenter.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

final class CalendarPresenter: ObservableObject {
    @Published var selectedType: CalendarSelectionType = .unscheduled
    
    @Published var internalDate: Date = Date()
    
    @Published var days: [CalendarItem] = []
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: internalDate)
    }
    
    init() {
        getDays()
    }
    
    func getDays() {
        days = (0..<7).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: internalDate)!
            let dayNumber = Calendar.current.component(.day, from: date)
            let weekday = Calendar.current.component(.weekday, from: date)
            
            let weekDay: CalendarItem.WeekDays
            switch weekday {
            case 1: weekDay = .sunday
            case 2: weekDay = .monday
            case 3: weekDay = .tuesday
            case 4: weekDay = .wednesday
            case 5: weekDay = .thursday
            case 6: weekDay = .friday
            case 7: weekDay = .saturday
            default: weekDay = .monday
            }
            
            return CalendarItem(number: dayNumber, weekDay: weekDay, date: date)
        }
    }
    
    func updateSelectedType(date: Date?) {
        if date == nil {
            selectedType = .unscheduled
        } else {
            selectedType = .day(date ?? Date())
        }
    }
    
    enum CalendarSelectionType: Equatable {
        case unscheduled
        case day(Date)
        
        static func == (lhs: CalendarSelectionType, rhs: CalendarSelectionType) -> Bool {
            switch (lhs, rhs) {
            case (.unscheduled, .unscheduled): return true
            case (.day(let lhsDate), .day(let rhsDate)): return lhsDate == rhsDate
            default: return false
            }
        }
    }
}


