//
//  TaskCell.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI
import SwiftfulUI

struct TaskCell: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
            HStack {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                Spacer()
                VStack {
                    HStack {
                        Text("Theme 1")
                            .foregroundStyle(.black)
                            .bold()
                        Spacer()
                        Text("20 xp")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                            .italic()
                    }
                    
                    HStack {
                        CustomProgressBar(
                            selection: 55,
                            range: 0...100,
                            backgroundColor: .gray,
                            foregroundColor: .green,
                            cornerRadius: 10,
                            height: 10)
                        .mask {
                            HStack(spacing: 1) {
                                ForEach(0..<7) { _ in
                                    Rectangle()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 80)
        .foregroundStyle(.primary)
    }
}

#Preview {
    TaskCell()
}
