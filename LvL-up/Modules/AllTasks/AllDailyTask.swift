//
//  AllDailyTask.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import Foundation
struct AllDailyTask: Identifiable {
    let id: UUID
    let img: String
    let reward: Int
    let title: String
    let upperBounds: Float
    let checkPoints: Int
    let typeProgress: TypeProgress
    
    enum TypeProgress: Int {
        case manually = 1
        case timer = 2
        case appActivity = 3
    }
    
    init(id: UUID, img: String, reward: Int, title: String, upperBounds: Float, checkPoints: Int, typeProgress: TypeProgress) {
        self.id = id
        self.img = img
        self.reward = reward
        self.title = title
        self.upperBounds = upperBounds
        self.checkPoints = checkPoints
        self.typeProgress = typeProgress
    }
    
    init(entity: DailyTaskEntity) {
        self.id = entity.id ?? UUID()
        self.img = entity.img ?? "Book"
        self.reward = Int(entity.reward)
        self.title = entity.title ?? "Task"
        self.upperBounds = entity.upperBounds
        self.checkPoints = Int(entity.checkPoints)
        self.typeProgress = TypeProgress(rawValue: Int(entity.typeProgress)) ?? .manually
    }
}

extension AllDailyTask {
    static var mockTasks: [AllDailyTask] {
        [
            AllDailyTask(
                id: UUID(),
                img: "flame.fill",
                reward: 10,
                title: "Пробежать 5 км",
                upperBounds: 10,
                checkPoints: 5,
                typeProgress: .manually
            ),
            AllDailyTask(
                id: UUID(),
                img: "book.fill",
                reward: 5,
                title: "Прочитать 30 страниц",
                upperBounds: 10,
                checkPoints: 3,
                typeProgress: .timer
            ),
            AllDailyTask(
                id: UUID(),
                img: "zzz",
                reward: 15,
                title: "Спать 8 часов",
                upperBounds: 10,
                checkPoints: 1,
                typeProgress: .appActivity
            ),
            AllDailyTask(
                id: UUID(),
                img: "cup.and.saucer.fill",
                reward: 3,
                title: "Выпить воды",
                upperBounds: 10,
                checkPoints: 5,
                typeProgress: .timer
            ),
            AllDailyTask(
                id: UUID(),
                img: "figure.walk",
                reward: 7,
                title: "10 000 шагов",
                upperBounds: 10,
                checkPoints: 4,
                typeProgress: .manually
            )
        ]
    }
}
