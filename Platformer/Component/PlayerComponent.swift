//
//  PlayerComponent.swift
//  Platformer
//
//  Created by Тимур Каримов on 03.11.2020.
//

import SpriteKit
import GameplayKit

class PlayerComponent: GKComponent, TouchControlDelegate {
    var touchControlNode: TouchControlNode?
    var character: CharacterNode?
    
    func setup(camera: SKCameraNode, scene: SKScene) {
        touchControlNode = TouchControlNode(frame: scene.frame)
        touchControlNode?.delegate = self
        touchControlNode?.position = .zero
        if let node = touchControlNode {
            camera.addChild(node)
        }
        
        if let nodeComponent = entity?.component(ofType: GKSKNodeComponent.self) {
            character = nodeComponent.node as? CharacterNode
        }
    }

    func onCommand(command: String?) {
        guard let command = command else { return }
        
        switch command {
        case "Left":
            character?.moveLeft = true
        case "cancel Left", "stop Left":
            character?.moveLeft = false
        case "Right":
            character?.moveRight = true
        case "cancel Right", "stop Right":
            character?.moveRight = false
        case "A":
            character?.jump = true
        case "cancel A", "stop A":
            character?.jump = false
        case "Down":
            character?.downPressed = true
        case "cancel Down", "stop Down":
            character?.downPressed = false
        default:
            print("command: \(String(describing: command))")
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        character?.stateMachine?.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
}
