//
//  EncounterManager.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 1/27/16.
//  Copyright © 2016 Philip Smith. All rights reserved.
//

import SpriteKit

class EncounterManager {
    // Store your enounter file names:
    let encounterNames: [String] = [
        "EncounterBats"
    ]
    // Each encounter is a SKNode, store an array:
    var encounters :[SKNode] = []
    
    init() {
        // Loop through each encounter scene:
        for encounterFileName in encounterNames {
            // Create a new node for the encounter:
            let encounter = SKNode()
            
            // Load this scene file into a SKScene instance:
            if let enounterScene = SKScene(fileNamed: encounterFileName) {
                // Loop through each placeholder, spawn the
                // appropriate game object:
                for placeholder in enounterScene.children {
                    if let node = placeholder as? SKNode {
                        switch node.name! {
                        case "Bat":
                            let bat = Bat()
                            bat.spawn(encounter, position: node.position)
                        case "Bee":
                            let bee = Bee()
                            bee.spawn(encounter, position: node.position)
                        case "Blade":
                            let blade = Blade()
                            blade.spawn(encounter, position: node.position)
                        case "Ghost":
                            let ghost = Ghost()
                            ghost.spawn(encounter, position: node.position)
                        case "MadFly":
                            let madFly = MadFly()
                            madFly.spawn(encounter, position: node.position)
                        case "GoldCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                        case "BronzeCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                        default:
                            print("Name error: \(node.name)")
                        }
                    }
                }
            }
            
            // Add the populated encounter node to the array:
            encounters.append(encounter)
        }
    }
    
    // We will call this addEncounterToWorld function from
    // the GameScene to append all the encounter nodes to the
    // world node from our GameScene
    func addEncountersToWorld(world: SKNode) {
        for index in 0...encounters.count - 1 {
            // Spawn the encounters behind the action, with
            // increasing height so they do not collide:
            encounters[index].position = CGPoint(x: -2000, y: index * 1000)
            world.addChild(encounters[index])
        }
    }
}
