//
//  CalendarView.swift
//  LvL-up
//
//  Created by MyBook on 03.05.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 5) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.fixed(50))
            ], spacing: 0) {
                CalendarCell(title: "Задачи", subTitle: "Без срока") {
                    //presenter.getData()
                }
                .foregroundStyle(.yellow)
                
                CalendarCell(title: "Расписание", subTitle: "Май") {
                    showDatePicker.toggle()
                }
                .foregroundStyle(.yellow)
                
                CalendarCell(title: "+", subTitle: "") {
                    //presenter.addTask()
                }
                .foregroundStyle(.yellow)
            }
            .padding(.horizontal)
            
            HStack {
                ForEach(10..<17) { i in
                    CalendarCell(title: "\(i)", subTitle: "Пн") {
                        //presenter.getData()
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker(
                    "Выберите дату",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                HStack {
                    Button("Отмена") {
                        showDatePicker = false
                    }
                    
                    Spacer()
                    
                    Button("Готово") {
                        print("Выбрана дата:", selectedDate)
                        showDatePicker = false
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    CalendarView()
}
