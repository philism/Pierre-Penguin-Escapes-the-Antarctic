//
//  Player.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/24/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "pierre.atlas")
    
    // Pierre has multiple animations. Right now we will
    // create an animation for flying up, and one for going down:
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        // If we run an action with a key, "flapAnimation",
        // we can later reference that key to remove the action.
        self.runAction(flyAnimation, withKey: "flapAnimation")
        
        // Create a physics body based on one frame of Pierre's animation.
        // We will use the third frame, when his wings are tucked in,
        // and use the size from the spawn function's parameters:
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3.png")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
        // Pierre will lose momentum quickly with a high linearDamping:
        self.physicsBody?.linearDamping = 0.9
        // Adult penguins weigh around 30kg
        self.physicsBody?.mass = 30
        // Prevent Pierre from rotating:
        self.physicsBody?.allowsRotation = false
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotateToAngle(0, duration: 0.475)
        rotateUpAction.timingMode = .EaseOut
        
        let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
        rotateDownAction.timingMode = .EaseIn
            
        // Create the flying animation:
        let flyFrames:[SKTexture] = [
        textureAtlas.textureNamed("pierre-flying-1.png"),
        textureAtlas.textureNamed("pierre-flying-2.png"),
        textureAtlas.textureNamed("pierre-flying-3.png"),
        textureAtlas.textureNamed("pierre-flying-4.png"),
        textureAtlas.textureNamed("pierre-flying-3.png"),
        textureAtlas.textureNamed("pierre-flying-2.png")
            ]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.03)
        // Group together the flying animation frames with a
        // rotation up:
        flyAnimation = SKAction.group([ SKAction.repeatActionForever(flyAction), rotateUpAction ])
        // Create the soaring animation, just one frame for now:
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png")]
        let soarAction = SKAction.animateWithTextures(soarFrames, timePerFrame: 1)
        // Group the soaring animation with the rotation down:
        soarAnimation = SKAction.group([
        SKAction.repeatActionForever(soarAction), rotateDownAction])
    }
    
    func onTap() {}
    
    func update() {

    }
}
