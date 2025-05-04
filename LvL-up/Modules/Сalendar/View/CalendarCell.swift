//
//  CalendarCell.swift
//  LvL-up
//
//  Created by MyBook on 03.05.2025.
//

import SwiftUI

struct CalendarCell: View {
    let title: String
    let subTitle: String
    let isSelected: Bool
    let action: ()->Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.yellow.opacity(0.1) : Color.background)
                .shadow(color: Color.secondary, radius: 1)
            
            VStack {
                Text(title)
                    .font(.title3)
                    .bold()
                if !subTitle.isEmpty {
                    Text(subTitle)
                        .foregroundStyle(.secondaryText)
                        .font(.subheadline)
                        .italic()
                }
            }
            .padding(.vertical, 5)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    CalendarCell(title: "23", subTitle: "Август", isSelected: false) {
        
    }
}
