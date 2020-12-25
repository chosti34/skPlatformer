//
//  ParallaxComponent.swift
//  Platformer
//
//  Created by Тимур Каримов on 25.12.2020.
//

import SpriteKit
import GameplayKit

class ParallaxComponent: GKComponent {
    @GKInspectable
    var layer: Int = 1
    
    var camera: SKCameraNode?
    var node: SKNode?
    
    var dx: CGFloat = 1.1
    var dy: CGFloat = 1.2
    var previousPosition: CGPoint?
    
    func initialise(with camera: SKCameraNode?) {
        if camera != nil {
            self.camera = camera
            previousPosition = self.camera?.position
        }
        
        if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self) {
            node = nodeComponent.node
        }
        
        switch layer {
        case 1:
            dx = 15
            dy = 5
        case 2:
            dx = 10
            dy = 4
        case 3:
            dx = 5
            dy = 2
        case 4:
            dx = 2
            dy = 1.9
        case 5:
            dx = 1.7
            dy = 1.5
        case 6:
            dx = 1.3
            dy = 1.25
        case 7:
            dx = 1.1
            dy = 1.2
        default:
            assert(false, "undefined parallax layer")
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let camera = camera else { return }
        guard let previous = previousPosition else { return }
        guard let node = node else { return }
        
        let diffX = (camera.position.x - previous.x) / dx
        let diffY = (camera.position.y - previous.y) / dy
        
        node.position = CGPoint(x: node.position.x + diffX, y: node.position.y + diffY)
        previousPosition = camera.position
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
}
