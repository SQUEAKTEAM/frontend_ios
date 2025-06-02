//
//  EditTaskView.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var presenter: EditTaskPresenter
    
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var customReward: String = ""
    @State private var showCustomRewardField = false
    @State private var hasDate: Bool
    @FocusState private var rewardFocus
    let isEdit: Bool
    
    var returnNewTask: (DailyTask) -> Void
    
    init(task: DailyTask, isEdit: Bool, returnNewTask: @escaping (DailyTask) -> Void) {
        self.isEdit = isEdit
        self._presenter = ObservedObject(initialValue: EditTaskPresenter(task: task))
        self._hasDate = State(initialValue: task.date != nil)
        self.returnNewTask = returnNewTask
    }
    
    let standardRewards = [5, 10, 15, 20, 50, 75, 100]
    
    let systemIcons = [
        // Общие
        "checkmark.circle.fill", "list.bullet", "text.badge.checkmark", "note.text",
        
        // Работа
        "briefcase.fill", "desktopcomputer", "laptopcomputer", "printer.fill",
        "doc.fill", "doc.text.fill", "folder.fill", "paperclip",
        
        // Учеба
        "book.fill", "book.closed.fill", "graduationcap.fill", "studentdesk",
        "pencil.tip", "highlighter", "pencil.and.ruler.fill", "scissors",
        
        // Дом
        "house.fill", "sofa.fill", "bed.double.fill", "lightbulb.fill",
        "washer.fill", "toilet.fill", "shower.fill", "key.fill",
        
        // Здоровье и спорт
        "heart.fill", "heart.text.square.fill", "cross.case.fill", "pills.fill",
        "figure.walk", "figure.run", "dumbbell.fill", "sportscourt.fill",
        
        // Еда
        "fork.knife", "takeoutbag.and.cup.and.straw.fill", "wineglass.fill",
        "birthday.cake.fill", "frying.pan.fill", "refrigerator.fill",
        
        // Покупки
        "cart.fill", "bag.fill", "creditcard.fill", "giftcard.fill",
        "tag.fill", "dollarsign.circle.fill", "cart.badge.plus",
        
        // Транспорт
        "car.fill", "bus.fill", "tram.fill", "bicycle", "scooter",
        "airplane", "fuelpump.fill", "steeringwheel",
        
        // Природа
        "leaf.fill", "tree.fill", "drop.fill", "flame.fill",
        "moon.fill", "sun.max.fill", "cloud.fill", "snowflake",
        
        // Животные
        "pawprint.fill", "teddybear.fill", "fish.fill", "bird.fill",
        "lizard.fill", "ant.fill", "hare.fill", "tortoise.fill",
        
        // Развлечения
        "gamecontroller.fill", "film.fill", "music.note", "tv.fill",
        "headphones", "paintbrush.fill", "theatermasks.fill", "photo.fill",
        
        // Путешествия
        "map.fill", "globe", "suitcase.fill", "beach.umbrella.fill",
        "binoculars.fill", "camera.fill", "mappin.and.ellipse",
        
        // Техника
        "iphone", "ipad", "applewatch",
        "battery.100", "wifi", "antenna.radiowaves.left.and.right",
        
        // Время и дата
        "clock.fill", "alarm.fill", "stopwatch.fill", "timer",
        "calendar", "clock.badge.checkmark", "hourglass",
        
        // Другое
        "trash.fill", "gearshape.fill", "questionmark.circle.fill",
        "exclamationmark.triangle.fill", "plus.circle.fill", "minus.circle.fill",
        "xmark.circle.fill"
    ]
    
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
            .navigationTitle(isEdit ? "Редактировать задачу" : "Создать задачу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .alert("Новая категория", isPresented: $showingNewCategoryAlert) { newCategoryAlert }
            .onAppear { setupInitialState() }
            .scrollIndicators(.hidden)
        }
        .task {
            await presenter.getCategories()
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
                LazyHGrid(rows: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
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
            customReward = ""
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
            .focused($rewardFocus)
            .keyboardType(.numberPad)
            .onChange(of: customReward) { newValue in
                if let value = Int(newValue) {
                    presenter.task.reward = value
                }
            }
            .onTapGesture {
                if rewardFocus {
                    rewardFocus = false
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
            Stepper(value: $presenter.task.checkPoints, in: 0...20) {
                Text("Количество: \(presenter.task.checkPoints)")
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
            ForEach(presenter.categories) { category in
                Text(category.title).tag(category)
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
            if presenter.task.date != nil {
                repeatToggle
            }
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
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Отмена") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    returnNewTask(presenter.task)
                    dismiss()
                }
            }
        }
    }
    
    private var newCategoryAlert: some View {
        Group {
            TextField("Название категории", text: $newCategoryName)
            Button("Добавить") {
                if !newCategoryName.isEmpty {
                    if !presenter.categories.contains(where: { $0.title == newCategoryName}) {
                        //presenter.categories.append(newCategoryName)
                        Task {
                            await presenter.createCategory(title: newCategoryName)
                        }
                    }
                    guard let category = presenter.categories.first(where: { $0.title == newCategoryName }) else { return }
                    presenter.task.category = category
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
        if !showCustomRewardField && !standardRewards.contains(where: { $0 == presenter.task.reward }){
            presenter.task.reward = standardRewards.first ?? 0
        } else if !customReward.isEmpty {
            guard let reward = Int(customReward) else { return }
            presenter.task.reward = reward
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditTaskView(task: DailyTask.mockTasks.first!, isEdit: true) { _ in
                
            }
        }
    }
}
