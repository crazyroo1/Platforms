//
//  GameScene.swift
//  Platforms
//
//  Created by Turner Eison on 3/19/19.
//  Copyright © 2019 Turner Eison. All rights reserved.
//

import SpriteKit
import GameplayKit

struct KeyCodes {
    static let space: UInt16 = 0x31
    static let d: UInt16 = 0x2
    static let a: UInt16 = 0x0
}
struct PC {
    static let player: UInt32 = 0x1 << 1
    static let world: UInt32 = 0x1 << 2
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    
    var isPressingSpace = false
    var wasPressingSpace = false
    var isPressingD = false
    var isPressingA = false
    
    override func sceneDidLoad() {
        guard let scene = scene else {return}
        self.lastUpdateTime = 0
        player.position = CGPoint(x: 0, y: 0)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = PC.player
        player.physicsBody?.collisionBitMask = PC.world
        scene.addChild(player)
        
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        scene.physicsBody?.isDynamic = false
        scene.physicsBody?.categoryBitMask = PC.world
        scene.physicsBody?.collisionBitMask = PC.player
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case KeyCodes.space:
            isPressingSpace = true
        case KeyCodes.a:
            isPressingA = true
        case KeyCodes.d:
            isPressingD = true
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case KeyCodes.space:
            isPressingSpace = false
            wasPressingSpace = false
        case KeyCodes.a:
            isPressingA = false
        case KeyCodes.d:
            isPressingD = false
        default:
            doNothing()
        }
    }
    
    private final func doNothing(){}
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        if isPressingSpace && !wasPressingSpace {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
            wasPressingSpace = true
        }
        if isPressingD {
            player.physicsBody?.applyForce(CGVector(dx: 150, dy: 0))
        }
        if isPressingA {
            player.physicsBody?.applyForce(CGVector(dx: -150, dy: 0))
        }
        
        
        self.lastUpdateTime = currentTime
    }
    
    var jumpForce: CGFloat {
        return (scene!.view!.frame.height / 8)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        guard let scene = scene else {return}
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        scene.physicsBody?.isDynamic = false
        scene.physicsBody?.categoryBitMask = PC.world
        scene.physicsBody?.collisionBitMask = PC.player
        
        if !scene.frame.contains(player.position) {
            player.position = CGPoint.zero
        }
        
        
    }
}
