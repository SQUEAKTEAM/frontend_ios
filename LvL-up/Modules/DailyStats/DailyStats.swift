//
//  DailyStats.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import Foundation

struct DailyStats: Codable {
    let countSuccess: Int
    let countMiddle: Int
    let countFailure: Int
    let reward: Float
}
