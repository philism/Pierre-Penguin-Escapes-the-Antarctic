//
//  Blade.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/29/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"enemies.atlas")
    var spinAnimation = SKAction()
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 185, height: 92)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        // Create a physics body shaped by the blade texture:
        self.physicsBody = SKPhysicsBody( texture: textureAtlas.textureNamed("blade-1.png"), size: size)
        self.physicsBody?.affectedByGravity = false
        // No dynamic body for the blade, which never moves:
        self.physicsBody?.dynamic = false
        createAnimations()
        self.runAction(spinAnimation)
    }
    
    func createAnimations() {
        let spinFrames:[SKTexture] = [
            textureAtlas.textureNamed("blade-1.png"),
            textureAtlas.textureNamed("blade-2.png")
        ]
        let spinAction = SKAction.animateWithTextures(spinFrames, timePerFrame: 0.07)
        spinAnimation = SKAction.repeatActionForever(spinAction)
    }
    
    func onTap() {}
}