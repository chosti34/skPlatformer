//
//  PhysicsContactHandler.swift
//  Platformer
//
//  Created by Тимур Каримов on 13.11.2020.
//

import Foundation
import SpriteKit
import GameplayKit

struct Collider {
    static let player: UInt32 = 0x01 << 0
    static let ground: UInt32 = 0x01 << 1
}

class PhysicsContactDelegate: NSObject, SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == Collider.player | Collider.ground {
            if let player = contact.bodyA.node as? CharacterNode {
                player.grounded = true
            } else if let player = contact.bodyB.node as? CharacterNode {
                player.grounded = true
            }
        }
    }
}
