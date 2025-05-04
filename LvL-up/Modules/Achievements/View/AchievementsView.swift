//
//  AchievementsView.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject var presenter = AchievementPresenter()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(presenter.achievements) { achievement in
                    AchievementCell<TaskCell>(achievement: achievement)
                        .foregroundStyle(
                            achievement.isCompleted ?
                            AnyShapeStyle(
                                LinearGradient(
                                    colors: [.yellow, .primary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            ) :
                            AnyShapeStyle(.primary)
                        )
                }
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(.clear)
            }
        }
        .task {
            await presenter.getData()
        }
    }
}

#Preview {
    AchievementsView()
}
