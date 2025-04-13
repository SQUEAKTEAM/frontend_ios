//
//  TaskDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import CoreData


final class TaskDataProvider: TaskProviderProtocol {
    private let coreDataManager: CoreDataManager<DailyTaskEntity>
    
    init(coreDataManager: CoreDataManager<DailyTaskEntity> = CoreDataManager<DailyTaskEntity>()) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchTasks() -> [DailyTaskEntity] {
        return coreDataManager.fetchAll()
    }
    
    func create(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void) {
        let entity = coreDataManager.create()
        coreDataManager.update {
            block(entity)
        }
    }
    
    func update(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void) {
        guard let dailyTaskEntity = findCurrentEntity(dailyTask: dailyTask) else { return }
        coreDataManager.update {
            block(dailyTaskEntity)
        }
    }
    
    func delete(_ dailyTask: DailyTask) {
        guard let dailyTaskEntity = findCurrentEntity(dailyTask: dailyTask) else { return }
        coreDataManager.delete(dailyTaskEntity)
    }
    
    private func findCurrentEntity(dailyTask: DailyTask) -> DailyTaskEntity? {
        return coreDataManager.fetchAll().first(where: { $0.id == dailyTask.id })
    }
}
