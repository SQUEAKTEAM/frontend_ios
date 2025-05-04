//
//  AllTaskPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 05.05.2025.
//

import XCTest
import SwiftUI
@testable import LvL_up

class AllTaskPresenterTests: XCTestCase {
    
    var presenter: AllTaskPresenter!
    var mockInteractor: MockTaskInteractor!
    var mockRouter: MockAllTaskRouter!
    var tasks: [DailyTask] = []
    var tasksBinding: Binding<[DailyTask]>!
    
    override func setUp() {
        super.setUp()
        
        // Создаем тестовые задачи
        tasks = [
            DailyTask(
                id: 1,
                img: "image1",
                isCompleted: false,
                reward: 10,
                title: "Task 1",
                checkPoints: 3,
                checkPoint: 0,
                isRepeat: false,
                isArchived: false,
                category: "Category1"
            ),
            DailyTask(
                id: 2,
                img: "image2",
                isCompleted: true,
                reward: 20,
                title: "Task 2",
                checkPoints: 5,
                checkPoint: 5,
                isRepeat: true,
                isArchived: true,
                category: "Category2"
            )
        ]
        
        // Создаем Binding для задач
        tasksBinding = Binding<[DailyTask]>(
            get: { self.tasks },
            set: { self.tasks = $0 }
        )
        
        mockInteractor = MockTaskInteractor()
        mockRouter = MockAllTaskRouter()
        
        presenter = AllTaskPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            tasks: tasksBinding
        )
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        tasks = []
        super.tearDown()
    }
    
    func testGetTasks() {
        // Тест для неархивированных задач
        let activeTasks = presenter.getTasks(false)
        XCTAssertEqual(activeTasks.count, 1)
        XCTAssertEqual(activeTasks.first?.id, 1)
        
        // Тест для архивированных задач
        let archivedTasks = presenter.getTasks(true)
        XCTAssertEqual(archivedTasks.count, 1)
        XCTAssertEqual(archivedTasks.first?.id, 2)
    }
    
}

// MARK: - Mock Classes

class MockAllTaskRouter: AllTaskRouterProtocol {
    var navigateToEditTaskCalled = false
    var passedTask: DailyTask?
    var editCompletion: ((DailyTask) -> Void)?
    
    func navigateToEditTask(for task: DailyTask, returnNewTask: @escaping (DailyTask) -> Void) -> AnyView {
        navigateToEditTaskCalled = true
        passedTask = task
        editCompletion = returnNewTask
        return AnyView(EmptyView())
    }
}
