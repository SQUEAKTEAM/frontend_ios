//
//  AllTaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import Foundation

final class AllTaskPresenter: ObservableObject {
    
    private let interactor: TaskInteractorProtocol
    
    @Published var tasks: [AllDailyTask] = []
    
    init(interactor: TaskInteractorProtocol = TaskInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        tasks = AllDailyTask.mockTasks
    }
}
