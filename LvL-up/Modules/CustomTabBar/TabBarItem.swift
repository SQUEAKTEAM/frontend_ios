//
//  TabBarItem.swift
//  LvL-up
//
//  Created by MyBook on 14.04.2025.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case dailyTask, tasks, statistics
    
    var iconName: String {
        switch self {
        case .dailyTask: return "list.bullet.clipboard"
        case .tasks: return "square.and.pencil"
        case .statistics: return "doc.text.magnifyingglass"
        }
    }
    
    var title: String {
        switch self {
        case .dailyTask: return "Задачи"
        case .tasks: return "Список задач"
        case .statistics: return "Статистика"
        }
    }
    
    var color: Color {
        switch self {
        case .dailyTask: return Color.yellow
        case .tasks: return Color.yellow
        case .statistics: return Color.yellow
        }
    }
    
    static var mock: [TabBarItem] {
        return [.dailyTask, .tasks, .statistics]
    }
}
