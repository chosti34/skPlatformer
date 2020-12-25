//
//  GameScene.swift
//  Platformer
//
//  Created by Тимур Каримов on 02.11.2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var contactHandler = PhysicsContactHandler()
    
    var characterNode: CharacterNode?
    
    private var lastUpdateTime : TimeInterval = 0
    
    var parallaxSystem: GKComponentSystem<ParallaxComponent>?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }

    override func didMove(to view: SKView) {
        parallaxSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        
        for entity in entities {
            parallaxSystem?.addComponent(foundIn: entity)
        }
        
        for component in parallaxSystem?.components ?? [] {
            component.initialise(with: camera)
        }
        
        if let node = childNode(withName: "Player") as? CharacterNode, let camera = camera {
            characterNode = node
            
            // Setup player component
            let playerComponent = node.entity?.component(ofType: PlayerComponent.self)
            playerComponent?.setup(camera: camera, scene: self)
            
            // Setup animation component
            let animationComponent = node.entity?.component(ofType: AnimationComponent.self)
            animationComponent?.setup()
            
            // Setup player node
            characterNode?.initialise()
        }
        physicsWorld.contactDelegate = contactHandler
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        parallaxSystem?.update(deltaTime: dt)
        self.lastUpdateTime = currentTime
    }
    
    override func didFinishUpdate() {
        guard let character = characterNode else { return }
        makeCameraFollowNode(node: character)
    }
    
    private func makeCameraFollowNode(node: SKNode) {
        guard let camera = camera else { return }
        camera.run(SKAction.move(to: CGPoint(x: node.position.x, y: node.position.y), duration: 0.5))
    }
}
