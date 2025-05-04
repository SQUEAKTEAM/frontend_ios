//
//  CalendarItem.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

struct CalendarItem {
    var number: Int
    var weekDay: WeekDays
    var date: Date
    
    enum WeekDays: String {
        case monday = "пн"
        case tuesday = "вт"
        case wednesday = "ср"
        case thursday = "чт"
        case friday = "пт"
        case saturday = "сб"
        case sunday = "вс"
    }
}
