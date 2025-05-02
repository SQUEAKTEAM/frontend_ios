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
    
    private var adjustedStartAngle: Angle {
        slice.startAngle + .degrees(gapSize/2)
    }
    
    private var adjustedEndAngle: Angle {
        slice.endAngle - .degrees(gapSize/2)
    }
    
    var body: some View {
        createPiePath(
            center: center,
            radius: radius,
            startAngle: adjustedStartAngle,
            endAngle: adjustedEndAngle,
            isSelected: slice.isSelected,
            shouldClose: true
        )
        .fill(slice.color)
        .overlay(
            createPiePath(
                center: center,
                radius: radius,
                startAngle: adjustedStartAngle,
                endAngle: adjustedEndAngle,
                isSelected: slice.isSelected,
                shouldClose: false
            )
            .stroke(Color.background, lineWidth: gapSize)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: slice.isSelected)
    }
    
    private func createPiePath(
        center: CGPoint,
        radius: CGFloat,
        startAngle: Angle,
        endAngle: Angle,
        isSelected: Bool,
        shouldClose: Bool
    ) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: isSelected ? radius * 1.05 : radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        if shouldClose {
            path.closeSubpath()
        }
        return path
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
