//
//  Ghost.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/29/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Ghost: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"enemies.atlas")
    var fadeAnimation = SKAction()
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 30, height: 44)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("ghost-frown.png")
        self.runAction(fadeAnimation)
        // Start the ghost semi-transparent:
        self.alpha = 0.8;
    }
    
    func createAnimations() {
        // Create a fade out action group:
        // The ghost becomes smaller and more transparent.
        let fadeOutGroup = SKAction.group([
            SKAction.fadeAlphaTo(0.3, duration: 2),
            SKAction.scaleTo(0.8, duration: 2)
            ])
        // Create a fade in action group:
        // The ghost returns to full size and transparency.
        let fadeInGroup = SKAction.group([
            SKAction.fadeAlphaTo(0.8, duration: 2),
            SKAction.scaleTo(1, duration: 2)
            ])
        // Package the groups into a sequence, then a
        // repeatActionForever action:
        let fadeSequence = SKAction.sequence([fadeOutGroup,  fadeInGroup])
        fadeAnimation = SKAction.repeatActionForever(fadeSequence)
    }
    
    func onTap() {}
    
}
