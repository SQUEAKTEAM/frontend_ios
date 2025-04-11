//
//  MainLvLView.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI
import SwiftfulUI

struct MainLvLView: View {
    @StateObject var presenter = MainLvLPresenter()

    var body: some View {
        ZStack {
            if let lvl = presenter.lvl {
                VStack {
                    lvlTitle(lvl: lvl.currentLvl)
                    
                    progressBar(currentExp: lvl.currentExp, upperBoundExp: lvl.upperBoundExp)
                    
                    testButton()
                }
            } else {
                Text("Загружаем ваш уровень!")
            }
        }
        .task {
            await presenter.getData()
        }
    }
}

#Preview {
    MainLvLView()
}

extension MainLvLView {
    func lvlTitle(lvl: Int) -> some View {
        Text("\(lvl) lvl")
            .font(.largeTitle)
            .bold()
            .animation(nil, value: presenter.lvl?.currentExp)
    }
    
    func progressBar(currentExp: Float, upperBoundExp: Float) -> some View {
        ZStack {
            CustomProgressBar(
                selection: currentExp,
                range: 0...upperBoundExp,
                backgroundColor: .gray,
                foregroundColor: .green,
                cornerRadius: 10,
                height: 20)
            Text("\(Int(currentExp))/\(Int(upperBoundExp))")
                .bold()
                .padding(.top)
                .animation(nil, value: presenter.lvl?.currentExp)
        }
    }
    
    func testButton() -> some View {
        Button {
            withAnimation(.smooth) {
                presenter.lvl?.currentExp += 1
            }
        } label: {
            Text("1 exp")
        }
    }
}
