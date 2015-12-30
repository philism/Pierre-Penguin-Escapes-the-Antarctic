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
        // Set a sky-blue background color:
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // Add the world node as a child of the scene:
        self.addChild(world)
        
        // Store the vertical center of the screen:
        screenCenterY = self.size.height / 2
        
        // Spawn the ground:
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        // Spawn the player:
        player.spawn(world, position: initialPlayerPosition)
        
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
