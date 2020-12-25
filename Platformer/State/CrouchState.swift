//
//  CrouchState.swift
//  Platformer
//
//  Created by Тимур Каримов on 16.11.2020.
//

import SpriteKit
import GameplayKit

class CrouchState: GKState {
    var character: CharacterNode
    
    init(with character: CharacterNode) {
        self.character = character
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is NormalState {
            character.color = UIColor.blue
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if !character.downPressed {
            stateMachine?.enter(NormalState.self)
        }
    }
}
