//
//  EditTaskView.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var task: Taskk
    
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var customReward: String = ""
    @State private var showCustomRewardField = false
    @State private var hasDate: Bool
    
    // Инициализатор для правильной установки начального значения hasDate
    init(task: Taskk) {
        self.task = task
        self._hasDate = State(initialValue: task.date != nil)
    }
    
    // Стандартные значения наград
    let standardRewards = [10, 20, 50, 100]
    
    // Доступные системные иконки
    let systemIcons = [
        "book.fill", "graduationcap.fill", "briefcase.fill",
        "house.fill", "heart.fill", "flame.fill",
        "leaf.fill", "cart.fill", "gamecontroller.fill",
        "pawprint.fill", "airplane", "car.fill"
    ]
    
    // Категории
    let categories = ["Работа", "Дом", "Спорт", "Учеба", "Другое"]
    
    var body: some View {
        NavigationView {
            Form {
                // Название задачи
                Section(header: Text("Название")) {
                    TextField("Введите название", text: $task.title)
                }
                
                // Иконка задачи
                Section(header: Text("Иконка")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(systemIcons, id: \.self) { iconName in
                                Image(systemName: iconName)
                                    .font(.system(size: 24))
                                    .frame(width: 50, height: 50)
                                    .background(task.img == iconName ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        task.img = iconName
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Награда
                Section(header: Text("Награда")) {
                    HStack {
                        ForEach(standardRewards, id: \.self) { reward in
                            Button(action: {
                                task.reward = reward
                                showCustomRewardField = false
                            }) {
                                Text("\(reward)")
                                    .padding(8)
                                    .background(task.reward == reward ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(task.reward == reward ? .white : .primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Button(action: {
                        showCustomRewardField.toggle()
                        if !showCustomRewardField {
                            task.reward = 0
                        }
                    }) {
                        HStack {
                            Text("Своя награда")
                            Spacer()
                            Image(systemName: showCustomRewardField ? "chevron.up" : "chevron.down")
                        }
                    }
                    
                    if showCustomRewardField {
                        TextField("Введите сумму", text: $customReward)
                            .keyboardType(.numberPad)
                            .onChange(of: customReward) { newValue in
                                if let value = Int(newValue) {
                                    task.reward = value
                                }
                            }
                    }
                }
                
                // Дата выполнения
                Section(header: Text("Дата выполнения")) {
                    Toggle("Установить дату", isOn: $hasDate)
                        .onChange(of: hasDate) { newValue in
                            if newValue {
                                // Если дата была nil, устанавливаем текущую дату
                                task.date = task.date ?? Date()
                            } else {
                                // Если переключатель выключен, устанавливаем nil
                                task.date = nil
                            }
                        }
                    
                    if hasDate, let binding = Binding($task.date) {
                        DatePicker(
                            "Выберите дату",
                            selection: binding,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: hasDate)
                
                // Остальные секции...
                // Количество чекпоинтов
                Section(header: Text("Промежуточные точки")) {
                    Stepper(value: $task.checkPoints, in: 0...10) {
                        Text("Чекпоинтов: \(task.checkPoints)")
                    }
                }
                
                // Категория
                Section(header: Text("Категория")) {
                    Picker("Выберите категорию", selection: $task.category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Button("Создать новую категорию") {
                        showingNewCategoryAlert = true
                    }
                }
                
                // Дополнительные опции
                Section {
                    Toggle("Повторять каждую неделю", isOn: $task.isRepeat)
                        .disabled(task.date == nil) // Отключаем если нет даты
                    Toggle("В архиве", isOn: $task.isArchived)
                }
            }
            .navigationTitle("Редактировать задачу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Новая категория", isPresented: $showingNewCategoryAlert) {
                TextField("Название категории", text: $newCategoryName)
                Button("Добавить") {
                    if !newCategoryName.isEmpty {
                        task.category = newCategoryName
                        newCategoryName = ""
                    }
                }
                Button("Отмена", role: .cancel) {}
            }
            .onAppear {
                if !standardRewards.contains(task.reward) {
                    customReward = "\(task.reward)"
                    showCustomRewardField = true
                }
            }
        }
    }
}

// Обновленная структура Task с опциональной датой
class Taskk: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var title: String
    @Published var img: String
    @Published var reward: Int
    @Published var isArchived: Bool
    @Published var checkPoints: Int
    @Published var isRepeat: Bool
    @Published var category: String
    @Published var date: Date? // Теперь опциональная
    
    init(title: String, img: String, reward: Int, isArchived: Bool,
         checkPoints: Int, isRepeat: Bool, category: String, date: Date?) {
        self.title = title
        self.img = img
        self.reward = reward
        self.isArchived = isArchived
        self.checkPoints = checkPoints
        self.isRepeat = isRepeat
        self.category = category
        self.date = date
    }
    
    static var new: Taskk {
        Taskk(
            title: "",
            img: "book.fill",
            reward: 20,
            isArchived: false,
            checkPoints: 1,
            isRepeat: false,
            category: "",
            date: nil
        )
    }
}

// Предпросмотр
struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Задача с датой
            EditTaskView(task: Taskk(
                title: "Прочитать книгу",
                img: "book.fill",
                reward: 20,
                isArchived: false,
                checkPoints: 3,
                isRepeat: false,
                category: "Учеба",
                date: Date()
            ))
            
            // Задача без даты
            EditTaskView(task: Taskk(
                title: "Позвонить маме",
                img: "heart.fill",
                reward: 10,
                isArchived: false,
                checkPoints: 1,
                isRepeat: false,
                category: "Дом",
                date: nil
            ))
        }
    }
}
