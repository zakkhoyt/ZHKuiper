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
                        self.physicsWorld.gravity = CGVectorMake(CGFloat(x), CGFloat(y))
                    })
                }
            }
        }
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
//        tapGestureRecognizer.numberOfTapsRequired = 4
//        self.view?.addGestureRecognizer(tapGestureRecognizer)

        
        // Add big node at top
        addMasterBB()
        
        addNodesByTimer()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addNodesByTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.1, block: { () -> Void in
            
            let randomX = arc4random_uniform(UInt32(self.frame.size.width))
//            self.addSpriteAtPoint(CGPoint(x: CGFloat(randomX), y: self.frame.size.height - 30))
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
            let point = touch.locationInNode(self)
//            let nodes = nodesAtPoint(point)
            
            let nodes = self.nodesAtPoint(point) as [SKNode]
            for node in nodes {
                if let nodeName = node.name {
                    if nodeName == "masterNode" {
                        self.masterBB!.remove({ () -> Void in
                            self.masterBB = nil
                            self.addMasterBB()
                        })
                    }
                }
            }
        }
        
        
//    
//        for touch in touches {
//            let point = touch.locationInNode(self)
//            addSpriteAtPoint(point)
//        }
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
            let bodyA = contact.bodyA.node as! ZHBBNode
            let bodyB = contact.bodyB.node as! ZHBBNode
            
            
//            var hit = false
//            if (bodyA.name == "bb" && bodyB.name == "masterNode") ||
//                (bodyB.name == "bb" && bodyA.name == "masterNode") {
//                hit = true
//            }
            var bb: ZHBBNode? = nil
            var masterBB: ZHBBNode? = nil
            
            if(bodyA.name == "masterNode"){
                masterBB = bodyA
            } else if bodyB.name == "masterNode" {
                masterBB = bodyB
            }
            
            if(bodyA.name == "bb"){
                bb = bodyA
            } else if bodyB.name == "bb" {
                bb = bodyB
            }
            
            if let bb = bb, masterBB = masterBB {
                bb.remove({ () -> Void in
                    
                })
                masterBB.remove({ () -> Void in
                    self.masterBB = nil
                    self.addMasterBB()
                })
            }
            
//            if hit == true {
//                bodyA.remove({ (Void) -> Void in
//                    
//                })
//                bodyB.remove({ (Void) -> Void in
//                    
//                })
//                
//                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
//                dispatch_after(delayTime, dispatch_get_main_queue()) {
//                    self.addMasterBB()
//                }
//            }

            
//            bodyB.remove()
//            matchCounter++
//            if let matchCountLabel = self.childNodeWithName("matchCountLabel") as? SKLabelNode {
//                matchCountLabel.text = "\(matchCounter) points"
//            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}