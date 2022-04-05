//
//  Start.swift
//  SwipeAnimation
//
//  Created by Nicolas Mariniello on 05/04/22.
//

import SwiftUI

struct Start: View {
    @State var grid: Grid = Grid(level: level)
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<grid.rows, id: \.self) { i in
                    HStack(spacing: 0) {
                        ForEach(grid.dots[i]) { dot in
                            DotComponent(dot: dot)
                        }
                    }
                }
            }
            .environmentObject(grid)
            .contentShape(Rectangle())
            .gesture(DragGesture().onEnded { value in
                if grid.dragGesture(translation: value.translation) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        grid.resetGrid()
                    }
                }
            })
        }
    }
}
