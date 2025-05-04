//
//  SchedulePresenter.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

final class SchedulePresenter: ObservableObject {
    
    @Published var tasks: [DailyTask] = []
    @Published var selectedDate: Date? = nil {
        didSet {
            Task {
                await getData()
            }
        }
    }
    
    private let interactor: TaskInteractorProtocol
    
    init(interactor: TaskInteractorProtocol = TaskInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        tasks = await interactor.loadTasks(at: selectedDate)
    }
}
