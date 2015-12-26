//
//  GameSprite.swift
//  Pierre Penguin Escapes the Antarctic
//
//  Created by Philip Smith on 12/24/15.
//  Copyright © 2015 Philip Smith. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas : SKTextureAtlas { get set }
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize)
    func onTap()
}
