//
//  EditTaskView.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var presenter: EditTaskPresenter
    
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var customReward: String = ""
    @State private var showCustomRewardField = false
    @State private var hasDate: Bool
    
    var returnNewTask: (DailyTask) -> Void
    
    // Инициализатор для правильной установки начального значения hasDate
    init(task: DailyTask, returnNewTask: @escaping (DailyTask) -> Void) {
        self._presenter = ObservedObject(initialValue: EditTaskPresenter(task: task))
        self._hasDate = State(initialValue: task.date != nil)
        self.returnNewTask = returnNewTask
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
                    titleSection
                    iconSection
                    rewardSection
                    dateSection
                    checkpointsSection
                    categorySection
                    optionsSection
                }
                .navigationTitle("Редактировать задачу")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .alert("Новая категория", isPresented: $showingNewCategoryAlert) { newCategoryAlert }
                .onAppear { setupInitialState() }
            }
        }
        
        // MARK: - Subviews
        
        private var titleSection: some View {
            Section(header: Text("Название")) {
                TextField("Введите название", text: $presenter.task.title)
            }
        }
        
        private var iconSection: some View {
            Section(header: Text("Иконка")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(systemIcons, id: \.self) { iconName in
                            iconButton(for: iconName)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        
        private func iconButton(for iconName: String) -> some View {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .frame(width: 50, height: 50)
                .background(presenter.task.img == iconName ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onTapGesture { presenter.task.img = iconName }
        }
        
        private var rewardSection: some View {
            Section(header: Text("Награда")) {
                standardRewardsView
                customRewardButton
                if showCustomRewardField {
                    customRewardField
                }
            }
        }
        
        private var standardRewardsView: some View {
            HStack {
                ForEach(standardRewards, id: \.self) { reward in
                    rewardButton(for: reward)
                }
            }
        }
        
        private func rewardButton(for reward: Int) -> some View {
            Button(action: {
                presenter.task.reward = reward
                showCustomRewardField = false
            }) {
                Text("\(reward)")
                    .padding(8)
                    .background(presenter.task.reward == reward ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(presenter.task.reward == reward ? .white : .primary)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        private var customRewardButton: some View {
            Button(action: toggleCustomRewardField) {
                HStack {
                    Text("Своя награда")
                    Spacer()
                    Image(systemName: showCustomRewardField ? "chevron.up" : "chevron.down")
                }
            }
        }
        
        private var customRewardField: some View {
            TextField("Введите сумму", text: $customReward)
                .keyboardType(.numberPad)
                .onChange(of: customReward) { newValue in
                    if let value = Int(newValue) {
                        presenter.task.reward = value
                    }
                }
        }
        
        private var dateSection: some View {
            Section(header: Text("Дата выполнения")) {
                dateToggle
                if hasDate, let binding = Binding($presenter.task.date) {
                    datePicker(binding: binding)
                }
            }
            .animation(.easeInOut, value: hasDate)
        }
        
        private var dateToggle: some View {
            Toggle("Установить дату", isOn: $hasDate)
                .onChange(of: hasDate) { newValue in
                    presenter.task.date = newValue ? (presenter.task.date ?? Date()) : nil
                }
        }
        
        private func datePicker(binding: Binding<Date>) -> some View {
            DatePicker(
                "Выберите дату",
                selection: binding,
                displayedComponents: [.date]
            )
            .transition(.opacity)
        }
        
        private var checkpointsSection: some View {
            Section(header: Text("Промежуточные точки")) {
                Stepper(value: $presenter.task.checkPoints, in: 0...10) {
                    Text("Чекпоинтов: \(presenter.task.checkPoints)")
                }
            }
        }
        
        private var categorySection: some View {
            Section(header: Text("Категория")) {
                categoryPicker
                newCategoryButton
            }
        }
        
        private var categoryPicker: some View {
            Picker("Выберите категорию", selection: $presenter.task.category) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(.menu)
        }
        
        private var newCategoryButton: some View {
            Button("Создать новую категорию") {
                showingNewCategoryAlert = true
            }
        }
        
        private var optionsSection: some View {
            Section {
                repeatToggle
                archiveToggle
            }
        }
        
        private var repeatToggle: some View {
            Toggle("Повторять каждую неделю", isOn: $presenter.task.isRepeat)
                .disabled(presenter.task.date == nil)
        }
        
        private var archiveToggle: some View {
            Toggle("В архиве", isOn: $presenter.task.isArchived)
        }
        
        private var toolbarContent: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    returnNewTask(presenter.task)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        private var newCategoryAlert: some View {
            Group {
                TextField("Название категории", text: $newCategoryName)
                Button("Добавить") {
                    if !newCategoryName.isEmpty {
                        presenter.task.category = newCategoryName
                        newCategoryName = ""
                    }
                }
                Button("Отмена", role: .cancel) {}
            }
        }
        
        // MARK: - Private Methods
        
        private func setupInitialState() {
            hasDate = presenter.task.date != nil
            if !standardRewards.contains(presenter.task.reward) {
                customReward = "\(presenter.task.reward)"
                showCustomRewardField = true
            }
        }
        
        private func toggleCustomRewardField() {
            showCustomRewardField.toggle()
            if !showCustomRewardField {
                presenter.task.reward = 0
            }
        }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditTaskView(task: DailyTask.mockTasks.first!) { _ in
                
            }
        }
    }
}
