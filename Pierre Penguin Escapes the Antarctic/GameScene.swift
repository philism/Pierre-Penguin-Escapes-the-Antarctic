//
//  GameScene.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 9/8/15.
//  Copyright (c) 2015 Philip Smith. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Create the world as a generic SKNode
    let world = SKNode()
    
    // create our bee sprite
    let bee = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)

        // Add the world node as a child of the scene
        self.addChild(world)
        // Call the new bee function
        self.addTheFlyingBee()
    }
    
    func addTheFlyingBee() {
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        // Notice we now attach our bee node to the world node:
        world.addChild(bee)
        
        // Find our new bee texture atlas
        let beeAtlas = SKTextureAtlas(named:"bee.atlas")
        // Grab the two bee frames from the texture atlas in an array
        // Note: Check out the syntax explicitly declaring beeFrames
        // as an array of SKTextures. This is not strictly necessary,
        // but it makes the intent of the code more readable, so I
        // chose to include the explicit type declaration here:
        let beeFrames:[SKTexture] = [
            beeAtlas.textureNamed("bee.png"),
            beeAtlas.textureNamed("bee_fly.png")]
        // Create a new SKAction to animate between the frames once
        let flyAction = SKAction.animateWithTextures(beeFrames,
            timePerFrame: 0.14)
        // Create an SKAction to run the flyAction repeatedly
        let beeAction = SKAction.repeatActionForever(flyAction)
        // Instruct our bee to run the final repeat action:
        bee.runAction(beeAction)
        
        // Set up new actions to move our bee back and forth:
        let pathLeft = SKAction.moveByX(-200, y: -10, duration: 2)
        let pathRight = SKAction.moveByX(200, y: 10, duration: 2)
        // These two scaleXTo actions flip the texture back and forth
        // We will use these to turn the bee to face left and right
        let flipTextureNegative = SKAction.scaleXTo(-1, duration: 0)
        let flipTexturePositive = SKAction.scaleXTo(1, duration: 0)
        // Combine actions into a cohesive flight sequence for our bee
        let flightOfTheBee = SKAction.sequence([pathLeft,
            flipTextureNegative, pathRight, flipTexturePositive])
        // Last, create a looping action that will repeat forever
        let neverEndingFlight =
        SKAction.repeatActionForever(flightOfTheBee)
        // Tell our bee to run the flight path, and away it goes!
        bee.runAction(neverEndingFlight)
    }
    
    override func didSimulatePhysics() {
        // To find the correct position, subtract half of the
        // scene size from the bee's position, adjusted for any
        // world scaling.
        // Multiply by -1 and you have the adjustment to keep our
        // sprite centered:
        let worldXPos = -(bee.position.x * world.xScale -
            (self.size.width / 2))
        let worldYPos = -(bee.position.y * world.yScale -
            (self.size.height / 2))
        // Move the world so that the bee is centered in the scene
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
