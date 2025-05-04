//
//  HomeView.swift
//  LvL-up
//
//  Created by MyBook on 14.04.2025.
//

import SwiftUI

struct HomeView: View {
    @State var tabSelection: TabBarItem = .dailyTask
    
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
            
        }
    }
}

#Preview {
    HomeView()
}
