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
    
    @State private var selection: Double = 55
    @State private var range: ClosedRange<Double> = 0...100

    var body: some View {
        if let lvl = presenter.lvl {
            VStack {
                Text("\(lvl.currentLvl) lvl")
                    .font(.largeTitle)
                    .bold()
                ZStack {
                    CustomProgressBar(
                        selection: lvl.current_exp,
                        range: 0...lvl.upperBound_exp,
                        backgroundColor: .gray,
                        foregroundColor: .green,
                        cornerRadius: 10,
                        height: 20)
                    Text("\(Int(lvl.current_exp))/\(Int(lvl.upperBound_exp))")
                        .bold()
                        .padding(.top)
                }
            }
            
        } else {
            Text("Загружаем ваш уровень!")
                .task {
                    await presenter.getData()
                }
        }
    }
}

#Preview {
    MainLvLView()
}
