//
//  Achievement.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

struct Achievement: Identifiable {
    let id: Int
    let title: String
    let currentXp: Int
    let upperBounds: Int
    let reward: Int
    let isCompleted: Bool
    
    func convertToDailyTask() -> DailyTask {
        DailyTask(id: id, img: "medal.fill", isCompleted: isCompleted, reward: reward, title: title, checkPoints: upperBounds, checkPoint: currentXp, category: "")
    }
    
    func updateCurrentXp(_ currentXp: Int) -> Achievement {
        Achievement(id: id, title: title, currentXp: currentXp, upperBounds: upperBounds, reward: reward, isCompleted: currentXp >= upperBounds)
    }
    
    static let mockAchievements: [Achievement] = [
        // === Ежедневные задачи ===
        Achievement(
            id: 1,
            title: "Выполни 3 задачи за день",
            currentXp: 0,
            upperBounds: 3,
            reward: 10,
            isCompleted: false
        ),
        Achievement(
            id: 2,
            title: "Выполни 5 задач за день",
            currentXp: 2,
            upperBounds: 5,
            reward: 20,
            isCompleted: false
        ),
        Achievement(
            id: 21,
            title: "Утренний ритуал (выполни задачу до 9 утра)",
            currentXp: 1,
            upperBounds: 1,
            reward: 15,
            isCompleted: true
        ),
        
        // === Недельные задачи ===
        Achievement(
            id: 3,
            title: "Выполни 15 задач за неделю",
            currentXp: 8,
            upperBounds: 15,
            reward: 50,
            isCompleted: false
        ),
        Achievement(
            id: 4,
            title: "Закончи неделю без пропусков",
            currentXp: 0,
            upperBounds: 7,
            reward: 30,
            isCompleted: false
        ),
        Achievement(
            id: 22,
            title: "Неделя продуктивности (5+ задач каждый день)",
            currentXp: 7,
            upperBounds: 7,
            reward: 70,
            isCompleted: true
        ),
        
        // === Месячные задачи ===
        Achievement(
            id: 23,
            title: "Месяц без пропусков",
            currentXp: 15,
            upperBounds: 30,
            reward: 150,
            isCompleted: false
        ),
        Achievement(
            id: 24,
            title: "100 задач за месяц",
            currentXp: 42,
            upperBounds: 100,
            reward: 200,
            isCompleted: false
        ),
        
        // === Разовые достижения ===
        Achievement(
            id: 5,
            title: "Первая выполненная задача",
            currentXp: 1,
            upperBounds: 1,
            reward: 5,
            isCompleted: true
        ),
        Achievement(
            id: 6,
            title: "Выполни 100 задач всего",
            currentXp: 42,
            upperBounds: 100,
            reward: 100,
            isCompleted: false
        ),
        Achievement(
            id: 25,
            title: "500 задач всего",
            currentXp: 327,
            upperBounds: 500,
            reward: 500,
            isCompleted: false
        ),
        
        // === Специальные достижения ===
        Achievement(
            id: 7,
            title: "Выполни все дневные задачи 3 дня подряд",
            currentXp: 1,
            upperBounds: 3,
            reward: 40,
            isCompleted: false
        ),
        Achievement(
            id: 8,
            title: "Выполни задачу с первого раза",
            currentXp: 0,
            upperBounds: 1,
            reward: 15,
            isCompleted: false
        ),
        Achievement(
            id: 26,
            title: "Эксперт (10 задач без ошибок)",
            currentXp: 7,
            upperBounds: 10,
            reward: 80,
            isCompleted: false
        ),
        Achievement(
            id: 27,
            title: "Спринт (5 задач за 1 час)",
            currentXp: 0,
            upperBounds: 5,
            reward: 60,
            isCompleted: false
        ),
        
        // === Юбилейные достижения ===
        Achievement(
            id: 28,
            title: "7 дней подряд",
            currentXp: 6,
            upperBounds: 7,
            reward: 77,
            isCompleted: false
        ),
        Achievement(
            id: 29,
            title: "30 дней подряд",
            currentXp: 14,
            upperBounds: 30,
            reward: 300,
            isCompleted: false
        ),
        Achievement(
            id: 30,
            title: "100 дней подряд",
            currentXp: 0,
            upperBounds: 100,
            reward: 1000,
            isCompleted: false
        ),
        
        // === Социальные достижения ===
        Achievement(
            id: 31,
            title: "Поделись результатами",
            currentXp: 1,
            upperBounds: 1,
            reward: 20,
            isCompleted: true
        ),
        Achievement(
            id: 32,
            title: "Пригласи друга",
            currentXp: 0,
            upperBounds: 1,
            reward: 50,
            isCompleted: false
        )
    ]
}
