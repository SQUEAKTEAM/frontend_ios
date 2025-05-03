//
//  CalendarView.swift
//  LvL-up
//
//  Created by MyBook on 03.05.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var showDatePicker = false
    @Binding var selectedDate: Date?
    @StateObject var presenter = CalendarPresenter()
    
    var body: some View {
        VStack(spacing: 5) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.fixed(50))
            ], spacing: 0) {
                CalendarCell(title: "Задачи", subTitle: "Без срока", isSelected: presenter.selectedType == .unscheduled) {
                    selectedDate = nil
                }
                .foregroundStyle(.yellow)
                
                CalendarCell(title: "Расписание", subTitle: presenter.currentMonth, isSelected: false) {
                    showDatePicker.toggle()
                }
                .foregroundStyle(.yellow)
                
                CalendarCell(title: "+", subTitle: "", isSelected: false) {
                    //presenter.addTask()
                }
                .foregroundStyle(.yellow)
            }
            .padding(.horizontal)
            
            HStack {
                ForEach(presenter.days, id: \.weekDay) { day in
                    CalendarCell(title: String(day.number), subTitle: day.weekDay.rawValue, isSelected: presenter.selectedType == .day(day.date)) {
                        presenter.internalDate = day.date
                        selectedDate = presenter.internalDate
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
                    selection: $presenter.internalDate,
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
                        selectedDate = presenter.internalDate
                        presenter.getDays()
                        showDatePicker = false
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
        .onChange(of: selectedDate) { date in
            presenter.updateSelectedType(date: date)
        }
    }
}

#Preview {
    CalendarView(selectedDate: .constant(Date()))
}
