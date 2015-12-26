//
//  Bee.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/24/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Bee: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named:"bee.atlas")
    var flyAnimation = SKAction()
    
    // The spawn function will be used to place the bee into
    // the world. Note how we set a default value for the size
    // parameter, since we already know the size of a bee
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 28, height: 24)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    // Our bee only implements one texture based animation.
    // But some classes may be more complicated,
    // So we break out the animation building into this function:
    func createAnimations() {
        let flyFrames: [SKTexture] = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
    
    // onTap is not wired up yet, but we have to implement this
    // function to adhere to our protocol.
    // We will explore touch events in the next chapter.
    func onTap() {}
}
