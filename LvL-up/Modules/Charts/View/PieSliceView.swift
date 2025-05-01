//
//  PieSliceView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//
import SwiftUI

struct PieSliceView: View {
    let slice: PieSlice
    let center: CGPoint
    let radius: CGFloat
    let gapSize: CGFloat // Размер промежутка в градусах
    
    var body: some View {
        let adjustedStartAngle = slice.startAngle + .degrees(gapSize/2)
        let adjustedEndAngle = slice.endAngle - .degrees(gapSize/2)
        
        Path { path in
            path.move(to: center)
            path.addArc(
                center: center,
                radius: slice.isSelected ? radius * 1.05 : radius,
                startAngle: adjustedStartAngle,
                endAngle: adjustedEndAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(slice.color)
        .overlay(
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: slice.isSelected ? radius * 1.05 : radius,
                    startAngle: adjustedStartAngle,
                    endAngle: adjustedEndAngle,
                    clockwise: false
                )
            }
            .stroke(Color.background, lineWidth: gapSize)
        )
    }
}

struct PieSlice: Identifiable {
    let id = UUID()
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    var isSelected: Bool = false
    
    func changeSelected() -> PieSlice {
        PieSlice(startAngle: self.startAngle, endAngle: self.endAngle, color: self.color, isSelected: !self.isSelected)
    }
}

extension [PieSlice] {
    func selectedColors() -> [Color] {
        self.filter({ $0.isSelected }).map({ $0.color })
    }
}
