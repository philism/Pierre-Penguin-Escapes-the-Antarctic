//
//  Bat.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/29/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"enemies.atlas")
    var flyAnimation = SKAction()
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 44, height: 24)) {
        parentNode.addChild(self)
        createAnimations()
        self.position = position
        self.runAction(flyAnimation)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    func createAnimations() {
        // The Bat has 4 animation textures:
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bat-fly-1.png"),
            textureAtlas.textureNamed("bat-fly-2.png"),
            textureAtlas.textureNamed("bat-fly-3.png"),
            textureAtlas.textureNamed("bat-fly-4.png"),
            textureAtlas.textureNamed("bat-fly-3.png"),
            textureAtlas.textureNamed("bat-fly-2.png")
        ]
        let flyAction = SKAction.animateWithTextures(flyFrames,
            timePerFrame: 0.06)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
    
    func onTap() {}
}
