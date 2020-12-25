//
//  MathUtils.swift
//  Platformer
//
//  Created by Тимур Каримов on 16.11.2020.
//

import Foundation
import CoreGraphics
import SpriteKit

class MathHelper {
    static func approach(start: CGFloat, end: CGFloat, shift: CGFloat) -> CGFloat {
        if start < end {
            return min(start + shift, end)
        }
        return max(start - shift, end)
    }
    
    static func squashAndStretch(node: SKSpriteNode, xScale: CGFloat, yScale: CGFloat) {
        node.xScale = xScale
        node.yScale = yScale
    }
}
