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
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)

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
        
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        player.spawn(world, position: CGPoint(x: 150, y: 250))
        self.motionManager.startAccelerometerUpdates()
    }
    
    override func didSimulatePhysics() {
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 2))
        let worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        world.position = CGPoint(x: worldXPos, y: worldYPos)
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
