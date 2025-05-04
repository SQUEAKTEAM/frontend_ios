//
//  TaskDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import CoreData


final class TaskDataProvider: TaskProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    ///GET:  id: Int, checkPoint: Int, img: String, isCompleted: Bool, reward: Int, title: String, checkPoints: Int, isRepeat: Bool, isArchived: Bool,  category: String
    ///POST: date, user_id
    func fetchTasks(at date: Date?) async throws -> [DailyTask] {
//        let user_id = 1
//        let date = date
//        return try await apiManager.fetch("tasks/\(user_id)\(date)/")
        guard let date = date else {
            return DailyTask.mockTasks.filter { $0.date == nil }
        }
        
        let calendar = Calendar.current
        return DailyTask.mockTasks.filter { task in
            guard let taskDate = task.date else { return false }
            return calendar.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    ///GET:  id: Int, checkPoint: Int, img: String, isCompleted: Bool, reward: Int, title: String, checkPoints: Int, isRepeat: Bool, isArchived: Bool,  category: String
    ///POST: user_id
    func fetchTasks() async throws -> [DailyTask] {
//        return try await apiManager.fetch("tasks/\(user_id)/")
        return DailyTask.mockTasks
    }

    ///POST: id: Int, checkPoint: Int, img: String, isCompleted: Bool, reward: Int, title: String, checkPoints: Int, isRepeat: Bool, isArchived: Bool,  category: String, date: Date, userId: Int
    func create(dailyTask: DailyTask) async throws -> DailyTask {
//        let user_id = 1
//        let createdTask: DailyTask = try await APIManager.shared.post("create_task/", body: dailyTask)
        return dailyTask
    }
    
    func update(dailyTask: DailyTask) async throws -> DailyTask {
//        let updatedTask: DailyTask = try await APIManager.shared.put("update_task/\(dailyTask.id)", body: dailyTask)
        return dailyTask
    }
    
    func delete(_ id: Int) async throws {
//        try await APIManager.shared.delete("tasks/\(id)")
    }
}
