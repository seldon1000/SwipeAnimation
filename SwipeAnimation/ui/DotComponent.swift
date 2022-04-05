//
//  DotComponent.swift
//  SwipeAnimation
//
//  Created by Nicolas Mariniello on 05/04/22.
//

import SwiftUI

struct DotComponent: View {
    @EnvironmentObject var grid: Grid
    
    @State var diameter: CGFloat = 64
    
    var dot: Dot
    
    var body: some View {
        Circle()
            .fill(Color(dot.isObstacle ? dot.obstacleColor : dot.color))
            .frame(width: diameter, height: diameter)
            .overlay(Circle().strokeBorder(.black.opacity(0.35), lineWidth: diameter * (dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 0.35 : 0.0)))
            .scaleEffect(dot.coordinates == grid.currentDot && grid.dotsToWin > 0 ? 1.2 : (dot.isColored ? 1.0 : 0.0))
            .padding(6)
            .onAppear {
                diameter = UIScreen.main.bounds.width / CGFloat(grid.cols) - 17
            }
    }
}
