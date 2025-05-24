//
//  TaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation

final class TaskPresenter: ObservableObject {
    
    private let interactor: TaskInteractorProtocol
    
    @Published var updateCurrentLvlEx: Float = 0
    @Published var completedTask: [DailyTask] = []
    @Published var notCompletedTask: [DailyTask] = []
    
    init(interactor: TaskInteractorProtocol = TaskInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        let dailyTasks = await interactor.loadTasks(at: Date()).filter({ !$0.isArchived })
        completedTask = dailyTasks.filter { $0.isCompleted }
        notCompletedTask = dailyTasks.filter { !$0.isCompleted }
        
        let tasks = await interactor.loadTasks(at: nil)
        notCompletedTask = notCompletedTask + tasks
    }
    
    func updateCurrentProgress(to dailyTask: DailyTask, checkPoint: Int) {
        if checkPoint < 0 || checkPoint > dailyTask.checkPoints {
            return
        }
        
        let isCompleted = dailyTask.isCompleted
        updateMainLvl(dailyTask: dailyTask, checkPoint: checkPoint)
        
        let task = dailyTask.updateCurrentProgress(checkPoint)
        updateArraysLogic(task: task, isCompleted: isCompleted)
        
        Task {
            await update(task)
        }
    }
    
    func getNoCompletedTasks(_ isDaily: Bool) -> [DailyTask] {
        if isDaily {
            return notCompletedTask.filter({ $0.date != nil || $0.isRepeat })
        } else {
            return notCompletedTask.filter({ $0.date == nil && !$0.isRepeat })
        }
    }
    
    private func update(_ dailyTask: DailyTask) async {
        await interactor.update(dailyTask)
    }
    
    private func updateMainLvl(dailyTask: DailyTask, checkPoint: Int) {
        if dailyTask.checkPoint < checkPoint {
            updateCurrentLvlEx = dailyTask.calculateRewardForCheckPoint()            
        } else {
            updateCurrentLvlEx = -dailyTask.calculateRewardForCheckPoint()
        }
    }
    
    internal func updateArraysLogic(task: DailyTask, isCompleted: Bool) {
        if task.isCompleted && !isCompleted {
            guard let index = notCompletedTask.firstIndex(where: { $0.id == task.id }) else { return }
            notCompletedTask.remove(at: index)
            completedTask.append(task)
        } else if task.isCompleted == isCompleted {
            guard let index = notCompletedTask.firstIndex(where: { $0.id == task.id }) else { return }
            notCompletedTask[index] = task
        } else if !task.isCompleted && isCompleted {
            guard let index = completedTask.firstIndex(where: { $0.id == task.id }) else { return }
            completedTask.remove(at: index)
            notCompletedTask.append(task)
        }
    }
}
