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
    
    // Store whether we are flapping our wings or in free-fall:
    var flapping = false
    // Set a maximum upward force
    // 57,000 feels good to me, adjust to taste:
    let maxFlappingForce:CGFloat = 57000
    // Pierre should slow down when he flies too high:
    let maxHeight: CGFloat = 1000
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(soarAnimation, withKey: "soarAnimation")
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
        // If flapping, apply a new force to push Pierre higher.
        if self.flapping {
            var forceToApply = maxFlappingForce
                
            // Apply less force if Pierre is above position 600
            if position.y > 600 {
                // The higher Pierre goes, the more force we remove. 
                // These next three lines determine the force to subtract:
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
            
            // Limit Pierre's top speed as he climbs the y-axis.
            // This prevents him from gaining enough momentum to shoot
            // over our max height. We bend the physics for gameplay:
            if self.physicsBody?.velocity.dy > 300 {
                self.physicsBody?.velocity.dy = 300
            }
            // Set a constant velocity to the right:
            self.physicsBody?.velocity.dx = 200
        }
    }
    
    // Begin the flap animation, set flapping to true:
    func startFlapping() {
        self.removeActionForKey("soarAnimation")
        self.runAction(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stop the flap animation, set flapping to false:
    func stopFlapping() {
        self.removeActionForKey("flapAnimation")
        self.runAction(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
}
