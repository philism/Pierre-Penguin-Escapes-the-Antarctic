//
//  MadFly.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/29/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas =
    SKTextureAtlas(named:"enemies.atlas")
    var flyAnimation = SKAction()
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 61, height: 29)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("mad-fly-1.png"),
            textureAtlas.textureNamed("mad-fly-2.png")
        ]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
    
    func onTap() {}
}
