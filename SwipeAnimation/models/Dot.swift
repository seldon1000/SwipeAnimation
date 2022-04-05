//
//  Dot.swift
//  SwipeAnimation
//
//  Created by Nicolas Mariniello on 05/04/22.
//

class Dot: Identifiable {
    var isObstacle: Bool
    var isColored: Bool
    let coordinates: (Int, Int)
    let color: String
    let obstacleColor: String
    
    init(isObstacle: Bool = false, coordinates: (Int, Int)) {
        self.isObstacle = isObstacle
        self.isColored = isObstacle
        self.coordinates = coordinates
        color = "Orange\(Int.random(in: 1...3))"
        obstacleColor = "Obstacle\(Int.random(in: 1...2))"
    }
}
