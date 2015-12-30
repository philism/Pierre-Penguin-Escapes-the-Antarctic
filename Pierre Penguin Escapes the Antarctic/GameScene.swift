//
//  GameScene.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 9/8/15.
//  Copyright (c) 2015 Philip Smith. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    // Create the world as a generic SKNode
    let world = SKNode()
    let ground = Ground()
    let player = Player()
    let motionManager = CMMotionManager()
    var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)
        // Store the vertical center of the screen:
        screenCenterY = self.size.height / 2
        
        // Add the world node as a child of the scene
        self.addChild(world)
        
        // Create three new instances of the Bee class:
        let bee2 = Bee()
        let bee3 = Bee()
        let bee4 = Bee()
        // Use our spawn function to place the bees into the world:
        bee2.spawn(world, position: CGPoint(x: 325, y: 325))
        bee3.spawn(world, position: CGPoint(x: 200, y: 325))
        bee4.spawn(world, position: CGPoint(x: 50, y: 200))
        
        
        // Spawn a bat:
        let bat = Bat()
        bat.spawn(world, position: CGPoint(x: 400, y: 200))
        // A blade:
        let blade = Blade()
        blade.spawn(world, position: CGPoint(x: 300, y: 76))
        // A mad fly:
        let madFly = MadFly()
        madFly.spawn(world, position: CGPoint(x: 50, y: 50))
        // A bronze coin:
        let bronzeCoin = Coin()
        bronzeCoin.spawn(world, position: CGPoint(x: 490, y: 250))
        // A gold coin:
        let goldCoin = Coin()
        goldCoin.spawn(world, position: CGPoint(x: 460, y: 250))
        goldCoin.turnToGold()
        // A ghost!
        let ghost = Ghost()
        ghost.spawn(world, position: CGPoint(x: 50, y: 300))
        // The powerup star:
        let star = Star()
        star.spawn(world, position: CGPoint(x: 250, y: 250))
        
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        // Spawn the player:
        player.spawn(world, position: initialPlayerPosition)
        
        self.motionManager.startAccelerometerUpdates()
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }
    
    override func didSimulatePhysics() {
        var worldYPos:CGFloat = 0
        // Zoom the world as the penguin flies higher
        if (player.position.y > screenCenterY) {
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let scaleSubtraction = (percentOfMaxHeight > 1 ? 1 : percentOfMaxHeight) * 0.6
            let newScale = 1 - scaleSubtraction
            world.yScale = newScale
            world.xScale = newScale
            // The player is above half the screen size
            // so adjust the world on the y-axis to follow:
            worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        }
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 3))
        // Move the world for our adjustment:
        world.position = CGPoint(x: worldXPos, y: worldYPos)
            
        // Keep track of how far the player has flown
        playerProgress = player.position.x - initialPlayerPosition.x
        ground.checkForReposition(playerProgress)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        for touch in touches {
            // Find the location of the touch:
            let location = touch.locationInNode(self)
            // Locate the node at this location:
            let nodeTouched = nodeAtPoint(location)
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                // If this node adheres to GameSprite, call onTap:
                gameSprite.onTap()
            }
        }
        player.startFlapping()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(touches: Set<UITouch>!, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func update(currentTime: CFTimeInterval) {
        player.update()
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount : CGFloat
            var movement = CGVector()
        
            // Based on the device orientation, the tilt number
            // can indicate opposite user desires. The
            // UIApplication class exposes an enum that allows
            // us to pull the current orientation.
            // We will use this opportunity to explore Swift's
            // switch syntax and assign the correct force for the
            // current orientation:
        
            switch UIApplication.sharedApplication().statusBarOrientation {
                case .LandscapeLeft:
                    // The 20,000 number is an amount that felt right
                    // for our example, given Pierre's 30kg mass:
                    forceAmount = 20000
                case .LandscapeRight:
                    forceAmount = -20000
                default:
                    forceAmount = 0
            }
            // If the device is tilted more than 15% towards complete
            // vertical, then we want to move the Penguin:
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            }
            // Core Motion values are relative to portrait view.
            // Since we are in landscape, use y-values for x-axis.
            else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
        
            // Apply the force we created to the player
            player.physicsBody?.applyForce(movement)
        }
    }
}
