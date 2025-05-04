//
//  AchievementCell.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI
import SwiftfulUI

protocol TaskCellProtocol: View {
    init(task: DailyTask, isNeedMask: Bool)
}

struct AchievementCell<Cell: TaskCellProtocol>: View {
    @State var achievement: Achievement
    @State private var scale: CGFloat = 0
    
    init(achievement: Achievement) {
        self.achievement = achievement
    }

    var body: some View {
        Cell(task: achievement.convertToDailyTask(), isNeedMask: false)
            .scaleEffect(scale)
            .onAppear {
                scale = 0.5
                let currentXp = achievement.currentXp
                achievement = achievement.updateCurrentXp(0)
                withAnimation(.smooth(duration: 0.3)) {
                    scale = 1
                    achievement = achievement.updateCurrentXp(currentXp)
                }
            }
    }
}

#Preview {
    AchievementCell<TaskCell>(achievement: Achievement(id: 1, title: "Выполнить 12 заданий", currentXp: 5, upperBounds: 15, reward: 12, isCompleted: false))
}
