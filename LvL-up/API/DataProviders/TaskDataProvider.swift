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
    
    func fetchTasks(at date: Date?) async throws -> [DailyTask] {
        guard let date = date else {
            return try await apiManager.fetch("api/tasks/")
//            return DailyTask.mockTasks
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        return try await apiManager.fetch("api/tasks/\(dateString)/")
        
//                guard let date = date else {
//                    return DailyTask.mockTasks.filter { $0.date == nil }
//                }
        
//                let calendar = Calendar.current
//                return DailyTask.mockTasks.filter { task in
//                    guard let taskDate = task.date else { return false }
//                    return calendar.isDate(taskDate, inSameDayAs: date)
//                }
    }

    ///POST: id: Int, checkPoint: Int, img: String, isCompleted: Bool, reward: Int, title: String, checkPoints: Int, isRepeat: Bool, isArchived: Bool,  category: String, date: Date, userId: Int
    func create(dailyTask: DailyTask) async throws {        
        let _: EmptyResponse = try await APIManager.shared.post("api/task/", body: dailyTask)
    }
    
    func update(dailyTask: DailyTask) async throws {
        let _: EmptyResponse = try await APIManager.shared.put("api/task/", body: dailyTask)
//        return dailyTask
    }
    
    func delete(_ id: Int) async throws {
        try await APIManager.shared.delete("api/task/\(id)")
    }
}
