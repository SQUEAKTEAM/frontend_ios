//
//  Statistics.swift
//  LvL-up
//
//  Created by MyBook on 01.05.2025.
//

import Foundation

struct Statistics: Identifiable, Codable {
    let id: Int
    let countSuccess: Int
    let countMiddle: Int
    let countFailure: Int
    let title: String
    
    func createChartContent() -> [PieChartContent] {
        [PieChartContent(value: Double(countSuccess), color: .green),
         PieChartContent(value: Double(countMiddle), color: .yellow),
         PieChartContent(value: Double(countFailure), color: .red)]
    }
    
    static let mockStatistics = [
        Statistics(
            id: 1,
            countSuccess: 15,
            countMiddle: 5,
            countFailure: 2,
            title: "Здоровье"
        ),
        Statistics(
            id: 2,
            countSuccess: 10,
            countMiddle: 8,
            countFailure: 4,
            title: "Учеба"
        ),
        Statistics(
            id: 3,
            countSuccess: 20,
            countMiddle: 10,
            countFailure: 5,
            title: "Работа"
        ),
        Statistics(
            id: 4,
            countSuccess: 25,
            countMiddle: 3,
            countFailure: 1,
            title: "Развлечения"
        ),
        Statistics(
            id: 5,
            countSuccess: 12,
            countMiddle: 6,
            countFailure: 3,
            title: "Спорт"
        ),
        Statistics(
            id: 6,
            countSuccess: 8,
            countMiddle: 4,
            countFailure: 2,
            title: "Финансы"
        ),
        Statistics(
            id: 7,
            countSuccess: 30,
            countMiddle: 0,
            countFailure: 0,
            title: "Творчество"
        ),
        Statistics(
            id: 8,
            countSuccess: 7,
            countMiddle: 10,
            countFailure: 5,
            title: "Семья"
        ),
        Statistics(
            id: 9,
            countSuccess: 18,
            countMiddle: 2,
            countFailure: 1,
            title: "Саморазвитие"
        ),
        Statistics(
            id: 10,
            countSuccess: 5,
            countMiddle: 3,
            countFailure: 7,
            title: "Питание"
        )
    ]
}
