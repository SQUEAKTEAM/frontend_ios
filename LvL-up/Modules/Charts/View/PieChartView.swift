//
//  PieChartView.swift
//
//

import SwiftUI

struct PieChartContent {
    var value: Double
    var color: Color
}

extension [PieChartContent] {
    var total: Double {
        var s: Double = 0
        for content in self {
            s += content.value
        }
        return s
    }
}

struct PieChartView: View {
    @State private var slices: [PieSlice]
    @State private var scale: CGFloat = 0
    @State private var degrees: CGFloat = -360
    
    @Binding var value: Int?
    
    private let contents: [PieChartContent]
    
    init(contents: [PieChartContent], value: Binding<Int?>) {
        let totalValue = contents.total
        self.contents = contents
        self._value = value
        
        var startAngle: Double = 0
        var initialSlices: [PieSlice] = []
        
        for content in contents {
            if content.value == 0 {
                continue
            }
            let endAngle = startAngle + 360 * (content.value / totalValue)
            let slice = PieSlice(
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                color: content.color
            )
            initialSlices.append(slice)
            startAngle = endAngle
        }
        
        self._slices = State(initialValue: initialSlices)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.9
            
            ZStack {
                ForEach(slices) { slice in
                    PieSliceView(slice: slice, center: center, radius: radius, gapSize: slices.count == 1 ? 0 : 3)
                        .onTapGesture {
                            guard let index = slices.firstIndex(where: { $0.id == slice.id }) else { return }
                            
                            slices[index] = slices[index].changeSelected()
                            calculateValue()
                        }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        calculateValue()
                    }
                    .onChanged { value in
                        let touchLocation = value.location
                        selectSlice(at: touchLocation, in: geometry.size, center: center, radius: radius)
                    }
            )
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(degrees))
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            scale = 0
            degrees = -300
            withAnimation(.spring) {
                scale = 1
                degrees = 0
            }
        }
    }
    
    private func selectSlice(at location: CGPoint, in size: CGSize, center: CGPoint, radius: CGFloat) {
        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
        guard distance <= radius * 1.1 else {
            slices.indices.forEach { slices[$0].isSelected = false }
            return
        }
        
        var angle = atan2(dy, dx) * 180 / .pi
        if angle < 0 {
            angle += 360
        }
        
        for index in slices.indices {
            let slice = slices[index]
            let start = slice.startAngle.degrees
            let end = slice.endAngle.degrees
            
            if angle >= start && angle < end {
                slices.indices.forEach { i in
                    slices[i].isSelected = (i == index)
                    calculateValue()
                }
                return
            }
        }
    }
    
    private func calculateValue() {
        if slices.selectedColors().isEmpty {
            value = nil
            return
        }
        
        var total = 0
        for content in contents {
            if slices.selectedColors().contains(content.color) {
                total += Int(content.value)
            }
        }
        value = total
    }
}

#Preview {
    PieChartView(contents: [PieChartContent(value: 30, color: .green), PieChartContent(value: 22, color: .yellow), PieChartContent(value: 1, color: .red)], value: .constant(nil))
}
