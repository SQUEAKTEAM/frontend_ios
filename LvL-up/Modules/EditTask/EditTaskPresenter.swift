//
//  EditTaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

final class EditTaskPresenter: ObservableObject {
    @Published var task: DailyTask
    
    init(task: DailyTask) {
        self.task = task
    }
}
