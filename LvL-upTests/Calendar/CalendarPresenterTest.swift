//
//  CalendarPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 05.05.2025.
//

import XCTest
import SwiftUI
@testable import LvL_up

class CalendarPresenterTests: XCTestCase {
    
    var presenter: CalendarPresenter!
    var mockInteractor: MockTaskInteractor!
    var mockRouter: MockCalendarRouter!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockTaskInteractor()
        mockRouter = MockCalendarRouter()
        presenter = CalendarPresenter(interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertEqual(presenter.selectedType, .unscheduled)
        XCTAssertFalse(presenter.days.isEmpty)
        XCTAssertEqual(presenter.days.count, 7)
    }
    
    // MARK: - getDays() Tests
    
    func testGetDaysGeneratesCorrectNumberOfDays() {
        presenter.getDays()
        XCTAssertEqual(presenter.days.count, 7)
    }
    
    func testGetDaysGeneratesConsecutiveDates() {
        presenter.getDays()
        let dates = presenter.days.map { $0.date }
        
        for i in 1..<dates.count {
            let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: dates[i])!
            XCTAssertEqual(dates[i-1], previousDay)
        }
    }
    
    func testGetDaysStartsWithCurrentDate() {
        let today = Calendar.current.startOfDay(for: Date())
        presenter.internalDate = today
        presenter.getDays()
        
        XCTAssertEqual(presenter.days.first?.date, today)
    }
    
    // MARK: - currentMonth Tests
    
    func testCurrentMonthReturnsCorrectMonth() {
        let testDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 1).date!
        presenter.internalDate = testDate
        XCTAssertEqual(presenter.currentMonth, "Декабрь")
    }
    
    // MARK: - addNewTask Tests
    
    func testAddNewTaskCallsRouter() {
        _ = presenter.addNewTask { _ in }
        XCTAssertTrue(mockRouter.navigateToAddTaskCalled)
    }
    
    // MARK: - updateSelectedType Tests
    
    func testUpdateSelectedTypeWithNil() {
        presenter.updateSelectedType(date: nil)
        XCTAssertEqual(presenter.selectedType, .unscheduled)
    }
    
    func testUpdateSelectedTypeWithDate() {
        let testDate = Date()
        presenter.updateSelectedType(date: testDate)
        
        if case let .day(date) = presenter.selectedType {
            XCTAssertEqual(date, testDate)
        } else {
            XCTFail("Expected .day case")
        }
    }
    
    func testUpdateSelectedTypeEquality() {
        let date1 = Date()
        let date2 = date1.addingTimeInterval(3600)
        
        let type1 = CalendarPresenter.CalendarSelectionType.day(date1)
        let type2 = CalendarPresenter.CalendarSelectionType.day(date2)
        let type3 = CalendarPresenter.CalendarSelectionType.unscheduled
        
        XCTAssertEqual(type1, CalendarPresenter.CalendarSelectionType.day(date1))
        XCTAssertNotEqual(type1, type2)
        XCTAssertNotEqual(type1, type3)
        XCTAssertEqual(type3, CalendarPresenter.CalendarSelectionType.unscheduled)
    }
    
    // MARK: - CalendarItem Tests
    
    func testCalendarItemProperties() {
        let testDate = Date()
        let item = CalendarItem(
            number: 15,
            weekDay: .monday,
            date: testDate
        )
        
        XCTAssertEqual(item.number, 15)
        XCTAssertEqual(item.weekDay, .monday)
        XCTAssertEqual(item.date, testDate)
    }
    
    func testWeekDaysRawValues() {
        XCTAssertEqual(CalendarItem.WeekDays.monday.rawValue, "пн")
        XCTAssertEqual(CalendarItem.WeekDays.tuesday.rawValue, "вт")
        // Проверьте остальные дни недели аналогично
    }
}

// MARK: - Mock Classes

class MockCalendarRouter: CalendarRouterProtocol {
    var navigateToAddTaskCalled = false
    var stubbedTaskToReturn: DailyTask?
    
    func navigateToAddTask(returnNewTask: @escaping (DailyTask) -> Void) -> AnyView {
        navigateToAddTaskCalled = true
        if let task = stubbedTaskToReturn {
            returnNewTask(task)
        }
        return AnyView(EmptyView())
    }
    
    func navigateToEditTask(for task: DailyTask, completion: @escaping (DailyTask) -> Void) -> AnyView {
        return AnyView(EmptyView())
    }
}
