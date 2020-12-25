//
//  CharacterNode.swift
//  Platformer
//
//  Created by Тимур Каримов on 12.11.2020.
//

import GameplayKit
import SpriteKit

class CharacterNode: SKSpriteNode {
    var moveLeft = false
    var moveRight = false
    
    var downPressed = false
    
    var jump = false
    var landed = false
    var grounded = false

    var maxJump: CGFloat = 60.0

    var airAcceleration: CGFloat = 10
    var airDeceleration: CGFloat = 10
    var groundAcceleration: CGFloat = 20
    var groundDeceleration: CGFloat = 20
    
    var facing: CGFloat = 1.0
    
    var hSpeed: CGFloat = 0.0
    var walkSpeed: CGFloat = 100.0
    
    var stateMachine: GKStateMachine?

    private let initialState = NormalState.self

    func initialise() {
        stateMachine = GKStateMachine(states: buildStates())
        stateMachine?.enter(initialState)
    }

    private func buildStates() -> [GKState] {
        return [
            NormalState(with: self),
            CrouchState(with: self),
        ]
    }
}
