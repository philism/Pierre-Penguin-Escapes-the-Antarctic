//
//  Ground.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/24/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ground.atlas")
    // Create an optional property named groundTexture to store
    // the current ground texture:
    var groundTexture:SKTexture?

    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        // This is one of those unique situations where we use
        // non-default anchor point. By positioning the ground by
        // its top left corner, we can place it just slightly
        // above the bottom of the screen, on any of screen size.
        self.anchorPoint = CGPointMake(0, 1)
    
        // Default to the ice texture:
        if groundTexture == nil {
            groundTexture = textureAtlas.textureNamed("ice-tile.png")
        }
        // We will create child nodes to repeat the texture
        createChildren()
    
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: pointTopRight)
    }

    // Build child nodes to repeat the ground texture
    func createChildren() {
        // First, make sure we have a groundTexture value:
        if let texture = groundTexture {
            var tileCount: CGFloat = 0
            let textureSize = texture.size()
            // We will size the tiles at half the size
            // of their texture for retina sharpness:
            let tileSize = CGSize(width: textureSize.width / 2, height: textureSize.height / 2)
            // Build nodes until we cover the entire Ground width
            while tileCount * tileSize.width < self.size.width {
                let tileNode = SKSpriteNode(texture: texture)
                tileNode.size = tileSize
                tileNode.position.x = tileCount * tileSize.width
                // Position child nodes by their upper left corner
                tileNode.anchorPoint = CGPoint(x: 0, y: 1)
                // Add the child texture to the ground node:
                self.addChild(tileNode)
                
                tileCount++
            }
        }
    }
    
    // Implement onTap to adhere to the protocol
    func onTap() {}
}
