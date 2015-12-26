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
    let ground = Ground()
    let player = Player()
    
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
        
        let groundPosition = CGPoint(x: -self.size.width, y: 100)
        let groundSize = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        player.spawn(world, position: CGPoint(x: 150, y: 250))
        bee2.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 0))
        
        bee2.physicsBody?.mass = 0.2
    }
    
    override func didSimulatePhysics() {
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 2))
        let worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
