//
//  StatisticsView.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        VStack {
            ChartsView()
            AchievementsView()
                .padding(.horizontal)
        }
    }
}

#Preview {
    StatisticsView()
}
