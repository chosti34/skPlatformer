//
//  NormalState.swift
//  Platformer
//
//  Created by Тимур Каримов on 12.11.2020.
//

import GameplayKit

class NormalState: GKState {
    var character: CharacterNode
    
    init(with character: CharacterNode) {
        self.character = character
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is CrouchState {
            character.color = UIColor.red
            character.run(SKAction.scaleY(to: 1, duration: 0.05))
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let physicsBody = character.physicsBody else { return }
        
        let acceleration = character.grounded ? character.groundAcceleration : character.airAcceleration
        let decelartion = character.grounded ? character.groundDeceleration : character.airDeceleration
        
        if character.moveLeft && character.moveRight || !character.moveLeft && !character.moveRight {
            character.hSpeed = MathHelper.approach(start: character.hSpeed, end: 0, shift: decelartion)
        } else if character.moveLeft {
            character.facing = -1
            character.xScale = -1
            character.hSpeed = MathHelper.approach(start: character.hSpeed, end: -character.walkSpeed, shift: acceleration)
        } else if character.moveRight {
            character.facing = 1
            character.xScale = 1
            character.hSpeed = MathHelper.approach(start: character.hSpeed, end: character.walkSpeed, shift: acceleration)
        }
        
        if character.grounded {
            if !character.landed {
                MathHelper.squashAndStretch(node: character, xScale: 1.3 * character.facing, yScale: 0.7)
                physicsBody.velocity = CGVector(dx: physicsBody.velocity.dx, dy: 0.0)
                character.landed = true
            }
            if character.jump {
                physicsBody.applyImpulse(CGVector(dx: 0.0, dy: character.maxJump))
                character.grounded = false
                MathHelper.squashAndStretch(node: character, xScale: 0.7 * character.facing, yScale: 1.3)
            }
        }
        
        if !character.grounded {
            if physicsBody.velocity.dy < 0.0 {
                character.jump = false
            }
            if physicsBody.velocity.dy > 0.0 && !character.jump {
                physicsBody.velocity.dy *= 0.5
            }
            character.landed = false
        }
        
        if character.downPressed {
            character.run(SKAction.scaleY(to: 0.7, duration: 0.2))
            stateMachine?.enter(CrouchState.self)
        }
        
        character.xScale = MathHelper.approach(start: character.xScale, end: character.facing, shift: 0.05)
        character.yScale = MathHelper.approach(start: character.yScale, end: 1, shift: 0.05)
        
        physicsBody.velocity.dx = character.hSpeed
    }
}
