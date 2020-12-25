//
//  InputControlNode.swift
//  Platformer
//
//  Created by Тимур Каримов on 02.11.2020.
//

import Foundation
import SpriteKit

class TouchControlNode: SKSpriteNode {
    let alphaUnpressed: CGFloat = 0.5
    let alphaPressed: CGFloat = 0.9

    let buttonUp = SKSpriteNode(imageNamed: "Up")
    let buttonDown = SKSpriteNode(imageNamed: "Down")
    let buttonLeft = SKSpriteNode(imageNamed: "Left")
    let buttonRight = SKSpriteNode(imageNamed: "Right")
    
    let buttonA = SKSpriteNode(imageNamed: "A")
    let buttonB = SKSpriteNode(imageNamed: "B")
    let buttonX = SKSpriteNode(imageNamed: "X")
    let buttonY = SKSpriteNode(imageNamed: "Y")
    
    var pressedButtons = [SKSpriteNode]()
    var delegate: TouchControlDelegate?

    init(frame: CGRect) {
        super.init(texture: nil, color: .clear, size: frame.size)
        setupControls(frameSize: frame.size)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func isPressed(_ button: SKSpriteNode) -> Bool {
        return pressedButtons.contains(button)
    }

    private func allButtons() -> [SKSpriteNode] {
        return [buttonUp, buttonDown, buttonLeft, buttonRight, buttonX, buttonB, buttonY, buttonA]
    }
}

extension TouchControlNode {
    private func setupControls(frameSize: CGSize) {
        setupDirectionControls(frameSize: size)
        setupButtonControls(frameSize: size)
    }

    private func setupDirectionControls(frameSize: CGSize) {
        setupButton(sprite: buttonUp,
                    name: "Up",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: -frameSize.width / 3, y: -frameSize.height / 4 + node.size.height)
                    })
        setupButton(sprite: buttonDown,
                    name: "Down",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: -frameSize.width / 3, y: -frameSize.height / 4 - node.size.height)
                    })
        setupButton(sprite: buttonLeft,
                    name: "Left",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: -frameSize.width / 3 - node.size.width, y: -frameSize.height / 4)
                    })
        setupButton(sprite: buttonRight,
                    name: "Right",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: -frameSize.width / 3 + node.size.width, y: -frameSize.height / 4)
                    })
    }

    private func setupButtonControls(frameSize: CGSize) {
        setupButton(sprite: buttonX,
                    name: "X",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: frameSize.width / 3, y: -frameSize.height / 4 + node.size.height)
                    })
        setupButton(sprite: buttonB,
                    name: "B",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: frameSize.width / 3, y: -frameSize.height / 4 - node.size.height)
                    })
        setupButton(sprite: buttonY,
                    name: "Y",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: frameSize.width / 3 - node.size.width, y: -frameSize.height / 4)
                    })
        setupButton(sprite: buttonA,
                    name: "A",
                    scale: 0.1, positionBuilder: { (node) in
                        return CGPoint(x: frameSize.width / 3 + node.size.width, y: -frameSize.height / 4)
                    })
    }

    private func setupButton(
        sprite: SKSpriteNode,
        name: String,
        scale: CGFloat,
        positionBuilder: (_ sprite: SKSpriteNode) -> CGPoint
    ) {
        sprite.setScale(scale)
        sprite.position = positionBuilder(sprite)
        sprite.name = name
        sprite.zPosition = 10
        sprite.alpha = alphaUnpressed
        addChild(sprite)
    }
}

extension TouchControlNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let parent = parent else { return } // always should be camera
        
        for touch in touches {
            let location = touch.location(in: parent)
            
            for button in allButtons() {
                if button.contains(location) && !isPressed(button) {
                    pressedButtons.append(button)
                    delegate?.onCommand(command: button.name)
                }
                button.alpha = isPressed(button) ? alphaPressed : alphaUnpressed
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let parent = parent else { return } // always should be camera
        
        for touch in touches {
            let location = touch.location(in: parent)
            let previousLocation = touch.previousLocation(in: parent)
            
            for button in allButtons() {
                let hitTestCurrent = button.contains(location)
                let hitTestPrevious = button.contains(previousLocation)
                
                if hitTestCurrent && !hitTestPrevious {
                    assert(!isPressed(button))
                    pressedButtons.append(button)
                    delegate?.onCommand(command: button.name)
                } else if !hitTestCurrent && hitTestPrevious {
                    assert(isPressed(button))
                    pressedButtons.removeAll(where: { node in return button == node })
                    delegate?.onCommand(command: "cancel \(button.name ?? "")")
                }

                button.alpha = isPressed(button) ? alphaPressed : alphaUnpressed
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp(touches: touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp(touches: touches, withEvent: event)
    }
    
    private func onTouchUp(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let parent = parent else { return } // always should be camera
        
        for touch in touches {
            let location = touch.location(in: parent)
            let previousLocation = touch.previousLocation(in: parent)

            for button in allButtons() {
                if (button.contains(location) || button.contains(previousLocation)) && isPressed(button) {
                    pressedButtons.removeAll(where: { (node) in return node == button })
                    delegate?.onCommand(command: "stop \(button.name ?? "")")
                }
                button.alpha = isPressed(button) ? alphaPressed : alphaUnpressed
            }
        }
    }
}
