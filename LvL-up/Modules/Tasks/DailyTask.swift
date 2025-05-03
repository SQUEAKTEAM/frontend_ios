//
//  DailyTask.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import SwiftUI

struct DailyTaskSerializer: Codable {
    var task: DailyTask
    var userId: Int
}

struct DailyTask: Identifiable, Codable {
    let id: Int
    let checkPoint: Int
    let img: String
    let isCompleted: Bool
    let reward: Int
    let title: String
    let checkPoints: Int
    let isRepeat: Bool
    let isArchived: Bool
    let category: String
    let date: Date?
    
    init(id: Int, img: String, isCompleted: Bool, reward: Int, title: String, checkPoints: Int, checkPoint: Int = 0, isRepeat: Bool = false, isArchived: Bool = false, category: String, date: Date? = nil) {
        self.id = id
        self.img = img
        self.isCompleted = isCompleted
        self.reward = reward
        self.title = title
        self.checkPoints = checkPoints > 0 ? checkPoints : 1
        self.checkPoint = checkPoint
        self.isRepeat = isRepeat
        self.isArchived = isArchived
        self.category = category
        self.date = date
    }
    
    func updateCurrentProgress(_ checkPoint: Int) -> DailyTask {
        let isCompleted = self.checkPoints == checkPoint
        return DailyTask(id: self.id, img: self.img, isCompleted: isCompleted, reward: self.reward, title: self.title, checkPoints: checkPoints, checkPoint: checkPoint, isRepeat: self.isRepeat, isArchived: self.isArchived, category: self.category, date: self.date)
    }
    
    func calculateCurrentReward() -> String {
        let result = Float(self.reward) / Float(self.checkPoints) * Float(self.checkPoints - self.checkPoint)
        
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(format: "%.2f", result)
        }
    }
    
    func calculateRewardForCheckPoint() -> Float {
        Float(self.reward) / Float(self.checkPoints)
    }
    
    func getColor() -> Color {
        var hashValue = title.utf8.reduce(5381) { ($0 << 5) &+ $0 &+ Int($1) }
        
        let r = (hashValue >> 16) & 0xFF
        let g = (hashValue >> 8) & 0xFF
        let b = hashValue & 0xFF
        
        // Делаем цвета более насыщенными
        let red = CGFloat(max(100, r)) / 255.0
        let green = CGFloat(max(100, g)) / 255.0
        let blue = CGFloat(max(100, b)) / 255.0
        
        return Color(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
    }
}

extension DailyTask {
    static var mockTasks: [DailyTask] {
        [
            DailyTask(
                id: 1,
                img: "flame.fill",
                isCompleted: false,
                reward: 10,
                title: "Пробежать 5 км",
                checkPoints: 5,
                checkPoint: 3,
                isRepeat: true,
                isArchived: false,
                category: "Спорт",
                date: Date().addingTimeInterval(86400) // Завтра
            ),
            DailyTask(
                id: 2,
                img: "book.fill",
                isCompleted: false,
                reward: 5,
                title: "Прочитать 30 страниц",
                checkPoints: 3,
                checkPoint: 2,
                isRepeat: true,
                isArchived: false,
                category: "Образование",
                date: nil // Без конкретной даты
            ),
            DailyTask(
                id: 3,
                img: "zzz",
                isCompleted: true,
                reward: 15,
                title: "Спать 8 часов",
                checkPoints: 1,
                checkPoint: 1,
                isRepeat: true,
                isArchived: false,
                category: "Здоровье",
                date: Date() // Сегодня
            ),
            DailyTask(
                id: 4,
                img: "cup.and.saucer.fill",
                isCompleted: false,
                reward: 3,
                title: "Выпить 2 литра воды",
                checkPoints: 5,
                checkPoint: 0,
                isRepeat: true,
                isArchived: false,
                category: "Здоровье",
                date: nil
            ),
            DailyTask(
                id: 5,
                img: "figure.walk",
                isCompleted: false,
                reward: 7,
                title: "10 000 шагов",
                checkPoints: 4,
                checkPoint: 3,
                isRepeat: true,
                isArchived: false,
                category: "Фитнес",
                date: Date().addingTimeInterval(172800) // Послезавтра
            ),
            DailyTask(
                id: 6,
                img: "briefcase.fill",
                isCompleted: false,
                reward: 20,
                title: "Закончить проект",
                checkPoints: 8,
                checkPoint: 5,
                isRepeat: false,
                isArchived: false,
                category: "Работа",
                date: Date().addingTimeInterval(604800) // Через неделю
            ),
            DailyTask(
                id: 7,
                img: "house.fill",
                isCompleted: false,
                reward: 5,
                title: "Убраться в квартире",
                checkPoints: 3,
                checkPoint: 1,
                isRepeat: true,
                isArchived: true,
                category: "Дом",
                date: Date().addingTimeInterval(-86400) // Вчера (просрочено)
            ),
            DailyTask(
                id: 8,
                img: "heart.fill",
                isCompleted: false,
                reward: 8,
                title: "Медитация 15 минут",
                checkPoints: 1,
                checkPoint: 0,
                isRepeat: true,
                isArchived: false,
                category: "Ментальное здоровье",
                date: nil
            ),
            DailyTask(
                id: 9,
                img: "car.fill",
                isCompleted: true,
                reward: 12,
                title: "Помыть машину",
                checkPoints: 2,
                checkPoint: 2,
                isRepeat: false,
                isArchived: true,
                category: "Авто",
                date: Date().addingTimeInterval(-172800) // 2 дня назад
            )
        ]
    }
}
