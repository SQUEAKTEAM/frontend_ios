//
//  HomeView.swift
//  LvL-up
//
//  Created by MyBook on 14.04.2025.
//

import SwiftUI

struct HomeView: View {
    @State var tabSelection: TabBarItem = .dailyTask
    @State var showingStats = false
    @AppStorage("lastStatsShownDate") private var lastStatsShownDate: String = ""
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            CustomTabBarContainerView(selection: $tabSelection) {
                
                TasksView()
                    .tabBarItem(tab: .dailyTask, selection: $tabSelection)
                
                ScheduleView()
                    .tabBarItem(tab: .tasks, selection: $tabSelection)
                
                StatisticsView()
                    .tabBarItem(tab: .statistics, selection: $tabSelection)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            Button("show stats") {
                showingStats = true
            }
        }
        .sheet(isPresented: $showingStats) {
            DailyStatsView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            checkAndShowStats()
        }
    }
    
    private func checkAndShowStats() {
        let currentDate = Date().formatted(date: .complete, time: .omitted)
        
        if lastStatsShownDate != currentDate {
            lastStatsShownDate = currentDate
            showingStats = true
        }
    }
}

#Preview {
    HomeView()
}
