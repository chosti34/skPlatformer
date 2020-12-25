//
//  AnimationComponent.swift
//  Platformer
//
//  Created by Тимур Каримов on 18.11.2020.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    var character: CharacterNode?
    
    var idleAnimation: SKAction?
    var runAnimation: SKAction?
    var jumpAnimation: SKAction?
    var crouchAnimation: SKAction?
    
    func setup() {
        idleAnimation = SKAction(named: "Idle")
        runAnimation = SKAction(named: "Run")
        jumpAnimation = SKAction(named: "Jump")
        crouchAnimation = SKAction(named: "Crouch")
        
        if let nodeComponent = entity?.component(ofType: GKSKNodeComponent.self) {
            character = nodeComponent.node as? CharacterNode
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if character?.stateMachine?.currentState is NormalState {
            processNormalStateAnimation()
        } else if character?.stateMachine?.currentState is CrouchState {
            processCrouchStateAnimation()
        }
    }
    
    func processNormalStateAnimation() {
        guard let character = character else { return }
        guard let physicsBody = character.physicsBody else { return }
        
        guard let runAnimation = runAnimation else { return }
        guard let idleAnimation = idleAnimation else { return }
        guard let jumpAnimation = jumpAnimation else { return }
        
        if character.grounded {
            if character.moveLeft || character.moveRight {
                if character.action(forKey: "Run") == nil {
                    detachAnimationActionsBut(actionKey: "Run")
                    character.run(runAnimation, withKey: "Run")
                }
            } else {
                if character.action(forKey: "Idle") == nil {
                    detachAnimationActionsBut(actionKey: "Idle")
                    character.run(idleAnimation, withKey: "Idle")
                }
            }
        } else {
            if physicsBody.velocity.dy > 0 {
                if character.action(forKey: "Jump") == nil {
                    detachAnimationActionsBut(actionKey: "Jump")
                    character.run(jumpAnimation, withKey: "Jump")
                }
            }
        }
    }
    
    func processCrouchStateAnimation() {
        guard let character = character else { return }
        guard let crouchAnimation = crouchAnimation else { return }
        
        if character.action(forKey: "Crouch") == nil {
            detachAnimationActionsBut(actionKey: "Crouch")
            character.run(crouchAnimation, withKey: "Crouch")
        }
    }
    
    func detachAnimationActionsBut(actionKey: String) {
        guard let character = character else { return }
        let items = animationActionKeysBut(item: actionKey)
        for item in items {
            character.removeAction(forKey: item)
        }
    }
    
    func animationActionKeysBut(item: String) -> [String] {
        var items = ["Idle", "Run", "Jump", "Crouch"]
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
        return items
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
}
