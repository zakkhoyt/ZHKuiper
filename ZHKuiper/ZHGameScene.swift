//
//  ZHGameScene.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright (c) 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit
import CoreMotion


let kMaxBBCount = 150



class ZHGameScene: SKScene {
    
    var motion = CMMotionManager()
    var blockNode: SKShapeNode? = nil
    var point1: CGPoint = CGPointZero
    var point2: CGPoint = CGPointZero
    var ref = CGPathCreateMutable()
    var matchCounter: UInt = 0
    var startTime = NSDate()
    var masterBB: ZHBBNode? = nil
    
    override func didMoveToView(view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsWorld.speed = 5;
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self;
        
        var lastDate = NSDate()
        motion.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            if let x = motion?.gravity.x, let y = motion?.gravity.y {
                let now = NSDate()
                if now.timeIntervalSinceDate(lastDate) > 0.05 {
                    lastDate = now
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.physicsWorld.gravity = CGVectorMake(CGFloat(5*x), CGFloat(5*y))
                    })
                }
            }
        }
        
//        // Add big node at top
//        addMasterBB()
        
//        addNodesByTimer()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addNodesByTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.1, block: { () -> Void in
            
            let randomX = arc4random_uniform(UInt32(self.frame.size.width))
            self.addSpriteAtPoint(CGPoint(x: CGFloat(randomX), y: 0))
            }, repeats: true)

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
//            let point = touch.locationInNode(self)
//            let nodes = self.nodesAtPoint(point) as [SKNode]
//            for node in nodes {
//                if let nodeName = node.name {
//                    if nodeName == "masterNode" {
//                        self.masterBB!.remove({ () -> Void in
//                            self.masterBB = nil
//                            self.addMasterBB()
//                        })
//                    }
//                }
//            }
            let point = touch.locationInNode(self)
            addSpriteAtPoint(point)
        }
    }
    
    
    func addMasterBB() {
        if let _ = masterBB {
            return
        }
        
        let point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - 120)
        masterBB = ZHBBNode(nodeColor: ZHBBNodeColor.randomColor, point: point)
        if let masterBB = masterBB {
            masterBB.userInteractionEnabled = false
            masterBB.physicsBody?.dynamic = false
            masterBB.name = "masterNode"
            masterBB.xScale = 8.0
            masterBB.yScale = 8.0
            self.addChild(masterBB)
        }
    }
    
    func addSpriteAtPoint(point: CGPoint) {
        
        var counter = 0
        for node in self.children {
            if node.name == "bb" {
                counter++
            }
            if counter > kMaxBBCount {
                return
            }
        }
        
        let sprite = ZHBBNode(nodeColor: ZHBBNodeColor.randomColor, point: point);
        sprite.xScale = 0.1
        sprite.yScale = 0.1
        let growAction = SKAction.scaleTo(ZHBBNodeFullScale, duration: 0.1)
        self.addChild(sprite)
        sprite.runAction(growAction)
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


extension ZHGameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == contact.bodyB.contactTestBitMask {
            let bodyA = contact.bodyA.node as! ZHBBNode
            let bodyB = contact.bodyB.node as! ZHBBNode
            if bodyA.physicsBody!.contactTestBitMask == bodyB.physicsBody!.contactTestBitMask {
                bodyA.remove({ () -> Void in
                    
                })
                bodyB.remove({ () -> Void in
                    
                })
            }
//            
//            var bb: ZHBBNode? = nil
//            var masterBB: ZHBBNode? = nil
//            
//            if(bodyA.name == "masterNode"){
//                masterBB = bodyA
//            } else if bodyB.name == "masterNode" {
//                masterBB = bodyB
//            }
//            
//            if(bodyA.name == "bb"){
//                bb = bodyA
//            } else if bodyB.name == "bb" {
//                bb = bodyB
//            }
//            
//            if let bb = bb, masterBB = masterBB {
//                bb.remove({ () -> Void in
//                    
//                })
//                masterBB.remove({ () -> Void in
//                    self.masterBB = nil
//                    self.addMasterBB()
//                })
//            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}