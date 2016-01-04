//
//  GameScene.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright (c) 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit
import CoreMotion


let kMaxBBCount = 40

class GameScene: SKScene {
    
    var motion = CMMotionManager()
    var blockNode: SKShapeNode? = nil
    var point1: CGPoint = CGPointZero
    var point2: CGPoint = CGPointZero
    var ref = CGPathCreateMutable()
    var matchCounter: UInt = 0
    var startTime = NSDate()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsWorld.speed = 5;
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self;
        
        var lastDate = NSDate()
        motion.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            if let x = motion?.gravity.x, let y = motion?.gravity.y {
                let now = NSDate()
                if now.timeIntervalSinceDate(lastDate) > 0.1 {
                    lastDate = now
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.physicsWorld.gravity = CGVectorMake(CGFloat(x), CGFloat(y))
                    })
                }
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapGestureRecognizer.numberOfTapsRequired = 4
        self.view?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            point1 = touch.locationInNode(self)
        }
        touch(touches, withEvent: event)

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch(touches, withEvent: event)
    }
    
    func touch(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        for touch in touches {
            let point = touch.locationInNode(self)
            addSpriteAtPoint(point)
        }
    }
    
    func addSpriteAtPoint(point: CGPoint) {
        
        if self.children.count > kMaxBBCount {
            return
        }
        
        let random = arc4random_uniform(11)
        var color = ZHBBNodeColor.White
        switch random {
        case 0:
            color = .Black
        case 1:
            color = .Blue
        case 2:
            color = .Brown
        case 3:
            color = .Cyan
        case 4:
            color = .Green
        case 5:
            color = .Magenta
        case 6:
            color = .Orange
        case 7:
            color = .Purple
        case 8:
            color = .Red
        case 9:
            color = .White
        case 10:
            color = .Yellow
        default:
            color = .White
        }
        
        
        let sprite = ZHBBNode(nodeColor: color, point: point);

//        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//        sprite.runAction(SKAction.repeatActionForever(action))
        self.addChild(sprite)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        for child in self.children {
            child.runAction(fadeAction, completion: { () -> Void in
                child.removeFromParent()
            })
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == contact.bodyB.contactTestBitMask {
            print("contact")
            let bodyA = contact.bodyA.node as! ZHBBNode
            let bodyB = contact.bodyB.node as! ZHBBNode
            bodyA.remove()
            bodyB.remove()
            matchCounter++
            if let matchCountLabel = self.childNodeWithName("matchCountLabel") as? SKLabelNode {
                matchCountLabel.text = "\(matchCounter) points"
            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}