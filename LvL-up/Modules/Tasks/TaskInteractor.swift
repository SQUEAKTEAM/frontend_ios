//
//  TaskInteractor.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import CoreData

protocol TaskProviderProtocol {
    func fetchTasks() -> [DailyTaskEntity]
    func update(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void)
    func create(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void)
    func delete(_ dailyTask: DailyTask)
}

protocol TaskInteractorProtocol {
    func loadTasks() -> [DailyTask]
    func update(_ dailyTask: DailyTask)
    func create(_ dailyTask: DailyTask)
    func delete(_ dailyTask: DailyTask)
}

final class TaskInteractor: TaskInteractorProtocol {
    private let dataService: TaskProviderProtocol
    
    init(dataService: TaskProviderProtocol = TaskDataProvider()) {
        self.dataService = dataService
    }
    
    func loadTasks() -> [DailyTask] {
        return dataService.fetchTasks().map({ DailyTask(entity: $0) })
    }
    
    func update(_ dailyTask: DailyTask) {
        dataService.update(dailyTask: dailyTask) { dailyTaskEntity in
            self.fillEntity(dailyTaskEntity, dailyTask: dailyTask)
        }
    }
    
    func create(_ dailyTask: DailyTask) {
        dataService.create(dailyTask: dailyTask) { dailyTaskEntity in
            self.fillEntity(dailyTaskEntity, dailyTask: dailyTask)
        }
    }
    
    func delete(_ dailyTask: DailyTask) {
        dataService.delete(dailyTask)
    }
    
    private func fillEntity(_ dailyTaskEntity: DailyTaskEntity, dailyTask: DailyTask) {
        dailyTaskEntity.id = dailyTask.id
        dailyTaskEntity.currentProgress = dailyTask.currentProgress
        dailyTaskEntity.img = dailyTask.img
        dailyTaskEntity.isCompleted = dailyTask.isCompleted
        dailyTaskEntity.reward = Int16(dailyTask.reward)
        dailyTaskEntity.title = dailyTask.title
        dailyTaskEntity.upperBounds = dailyTask.upperBounds
        dailyTaskEntity.checkPoint = Int16(dailyTask.checkPoint)
        dailyTaskEntity.checkPoints = Int16(dailyTask.checkPoints)
    }
}
