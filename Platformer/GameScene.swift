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
    private var lastUpdateTime : TimeInterval = 0
    
    var characterNode: CharacterNode?
    var parallaxSystem: GKComponentSystem<ParallaxComponent>?
    var physicsContactDelegate = PhysicsContactDelegate()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }

    override func didMove(to view: SKView) {
        guard let player = childNode(withName: "Player") as? CharacterNode else { return }
        characterNode = player
        characterNode?.initialise()
        
        guard let camera = camera else { return }
        setCameraTilemapConstraint(camera)
        
        let playerComponent = characterNode?.entity?.component(ofType: PlayerComponent.self)
        playerComponent?.setup(camera: camera, scene: self)
        
        let animationComponent = characterNode?.entity?.component(ofType: AnimationComponent.self)
        animationComponent?.setup()
        
        physicsWorld.contactDelegate = physicsContactDelegate
        initialiseParallaxSystem()
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
    
    // https://stackoverflow.com/questions/35137563/clamping-camera-around-the-background-of-a-scene-in-spritekit
    private func setCameraTilemapConstraint(_ camera: SKCameraNode) {
        guard let tilemap = childNode(withName: "Ground Tile Map") as? SKTileMapNode else { return }
        let tilemapContentRect = tilemap.calculateAccumulatedFrame()
        
        let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
        
        let xInset = min(scaledSize.width / 2, tilemap.mapSize.width / 2)
        let yInset = min(scaledSize.height / 2, tilemap.mapSize.height / 2)
        let insetContentRect = tilemapContentRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        camera.constraints = [edgeConstraint]
    }
    
    private func initialiseParallaxSystem() {
        parallaxSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        for entity in entities {
            parallaxSystem?.addComponent(foundIn: entity)
        }
        for component in (parallaxSystem?.components ?? []) {
            component.initialise(with: camera)
        }
    }
}
