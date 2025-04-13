//
//  DailyTask.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import CoreData

struct DailyTask: Identifiable {
    let id: UUID
    let currentProgress: Float
    let checkPoint: Int
    let img: String
    let isCompleted: Bool
    let reward: Int
    let title: String
    let upperBounds: Float
    let checkPoints: Int
    
    init(id: UUID, currentProgress: Float, img: String, isCompleted: Bool, reward: Int, title: String, upperBounds: Float, checkPoints: Int, checkPoint: Int = 0) {
        self.id = id
        self.currentProgress = currentProgress
        self.img = img
        self.isCompleted = isCompleted
        self.reward = reward
        self.title = title
        self.upperBounds = upperBounds
        self.checkPoints = checkPoints
        self.checkPoint = checkPoint
    }
    
    init(entity: DailyTaskEntity) {
        self.id = entity.id ?? UUID()
        self.currentProgress = entity.currentProgress
        self.img = entity.img ?? "Book"
        self.isCompleted = entity.isCompleted
        self.reward = Int(entity.reward)
        self.title = entity.title ?? "Task"
        self.upperBounds = entity.upperBounds
        self.checkPoint = Int(entity.checkPoint)
        self.checkPoints = Int(entity.checkPoints)
    }
    
    func updateCurrentProgress(_ checkPoint: Int) -> DailyTask {
        let currentProgress = self.upperBounds / Float(self.checkPoints) * Float(checkPoint)
        let isCompleted = self.checkPoints == checkPoint
        return DailyTask(id: self.id, currentProgress: currentProgress, img: self.img, isCompleted: isCompleted, reward: self.reward, title: self.title, upperBounds: self.upperBounds, checkPoints: checkPoints, checkPoint: checkPoint)
    }
    
    func updateCurrentProgress(_ currentProgress: Float) -> DailyTask {
        let checkPoint = Int(currentProgress / (self.upperBounds / Float(self.checkPoints)))
        let isCompleted = currentProgress >= self.upperBounds
        return DailyTask(id: self.id, currentProgress: currentProgress, img: self.img, isCompleted: isCompleted, reward: self.reward, title: self.title, upperBounds: self.upperBounds, checkPoints: checkPoints, checkPoint: checkPoint)
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
}

extension DailyTask {
    static var mockTasks: [DailyTask] {
        [
            DailyTask(
                id: UUID(),
                currentProgress: 3,
                img: "flame.fill",
                isCompleted: false,
                reward: 10,
                title: "Пробежать 5 км",
                upperBounds: 10,
                checkPoints: 5
            ),
            DailyTask(
                id: UUID(),
                currentProgress: 8,
                img: "book.fill",
                isCompleted: false,
                reward: 5,
                title: "Прочитать 30 страниц",
                upperBounds: 10,
                checkPoints: 3
            ),
            DailyTask(
                id: UUID(),
                currentProgress: 10,
                img: "zzz",
                isCompleted: true,
                reward: 15,
                title: "Спать 8 часов",
                upperBounds: 10,
                checkPoints: 1
            ),
            DailyTask(
                id: UUID(),
                currentProgress: 0,
                img: "cup.and.saucer.fill",
                isCompleted: false,
                reward: 3,
                title: "Выпить воды",
                upperBounds: 10,
                checkPoints: 5
            ),
            DailyTask(
                id: UUID(),
                currentProgress: 6,
                img: "figure.walk",
                isCompleted: false,
                reward: 7,
                title: "10 000 шагов",
                upperBounds: 10,
                checkPoints: 4
            )
        ]
    }
}
