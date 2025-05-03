//
//  TaskInteractor.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation
import CoreData

protocol TaskProviderProtocol {
    func fetchTasks(at date: Date?) async throws -> [DailyTask]
    func fetchTasks() async throws -> [DailyTask]
    func create(dailyTask: DailyTask) async throws -> DailyTask
    func update(dailyTask: DailyTask) async throws -> DailyTask
    func delete(_ id: Int) async throws
}

protocol TaskInteractorProtocol {
    func loadTasks() async -> [DailyTask]
    func loadTasks(at date: Date?) async -> [DailyTask]
    func update(_ dailyTask: DailyTask) async -> DailyTask?
    func create(_ dailyTask: DailyTask) async -> DailyTask?
    func delete(_ dailyTask: DailyTask) async
}

final class TaskInteractor: TaskInteractorProtocol {
    private let dataService: TaskProviderProtocol
    
    init(dataService: TaskProviderProtocol = TaskDataProvider()) {
        self.dataService = dataService
    }
    
    func loadTasks() async -> [DailyTask] {
        return (try? await dataService.fetchTasks()) ?? []
    }
    
    func loadTasks(at date: Date?) async -> [DailyTask] {
        return (try? await dataService.fetchTasks(at: date)) ?? []
    }
    
    func update(_ dailyTask: DailyTask) async -> DailyTask? {
        return try? await dataService.update(dailyTask: dailyTask)
    }
    
    func create(_ dailyTask: DailyTask) async -> DailyTask? {
        return try? await dataService.create(dailyTask: dailyTask)
    }
    
    func delete(_ dailyTask: DailyTask) async {
        try? await dataService.delete(dailyTask.id)
    }
}
