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


let ZHGameSceneMaxDemoCount = UInt(3)

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
        
        setupGestures()
        setupGravity()
        showLabels()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        tapGesture.numberOfTapsRequired = 2
        tapGesture.numberOfTouchesRequired = 2
        self.view?.addGestureRecognizer(tapGesture)
    }
    
    func setupGravity() {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsWorld.speed = 2;
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self;
        
        if motion.deviceMotionAvailable == true {
            
            
//            var lastDate = NSDate()
            motion.deviceMotionUpdateInterval = 0.05;
            motion.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
                if let x = motion?.gravity.x, let y = motion?.gravity.y {
//                    let now = NSDate()
//                    if now.timeIntervalSinceDate(lastDate) > 0.05 {
//                        lastDate = now
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.physicsWorld.gravity = CGVectorMake(CGFloat(5*x), CGFloat(5*y))
                        })
//                    }
                }
            }
        } else {
            self.physicsWorld.gravity = CGVectorMake(CGFloat(0), CGFloat(-1))
        }
    }
    
    func showLabels() {

        

        
        
        let textInterval = NSTimeInterval(2.0)
        let taskInterval = NSTimeInterval(3.0)

        self.addLabelNode("Have fun!", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
            }) { () -> Void in
        }
        return

        
        
        if let demoCount = NSUserDefaults.standardUserDefaults().objectForKey("demoCount") as? UInt {
            // Only show demo so many times
            if demoCount >= ZHGameSceneMaxDemoCount {
                print("Max demo count reached")
                
                self.addLabelNode("Have fun!", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                    }) { () -> Void in
                }
                return
            }
            let newDemoCount = demoCount + 1
            NSUserDefaults.standardUserDefaults().setObject(newDemoCount, forKey: "demoCount")
            NSUserDefaults.standardUserDefaults().synchronize()

        } else {
            // Create user default if it doesn't exist
            NSUserDefaults.standardUserDefaults().setObject(UInt(0), forKey: "demoCount")
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        
        addLabelNode("Tap & drag to\nspawn shapes", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
//            self.addCancelDemoNode()
            self.demonstrateTaps()
            }) { () -> Void in
                self.addLabelNode("Use gravity by\ntilting the device", textInterval: textInterval, taskInterval: 6.0, taskBlock: { () -> Void in
//                    self.removeCancelDemoNode()
                    self.demonstrateGravity()
                    }) { () -> Void in
                        self.addLabelNode("When matching shapes\ntouch they disappear", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                            self.demonstrateCollision()
                            }) { () -> Void in
                                self.addLabelNode("Tap shapes to\nto make them jump", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                                    self.demonstrateEnertia()
                                    }) { () -> Void in
                                        self.addLabelNode("Double tap with\ntwo fingers to clear\nthe screen", textInterval: textInterval, taskInterval: 0, taskBlock: { () -> Void in
                                                self.clear()
                                            }) { () -> Void in
                                                self.addLabelNode("Have fun!", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                                                    }) { () -> Void in
                                                }
                                        }
                                }
                        }
                }
        }

    }
    
    func clear() {
        for node in self.children {
            if node.name == "bb" {
                if let bb = node as? ZHBBNode {
                    bb.remove(.Shrink, completion: { () -> Void in
                    })
                }
            }
        }
    }
    
    func demoRunning() -> Bool {
        if let _ = childNodeWithName("cancelNode") {
            return true
        }
        return false
    }
    
    func addCancelDemoNode() {
        let labelNode = NORLabelNode(fontNamed:"Chalkduster")
        labelNode.name = "cancelNode"
        labelNode.text = "Tap anywhere to skip demo"
        labelNode.fontSize = 14
        labelNode.horizontalAlignmentMode = .Center
        labelNode.verticalAlignmentMode = .Center
        labelNode.position = CGPoint(x:CGRectGetMidX(self.frame), y: 64)
        labelNode.alpha = 0
        self.addChild(labelNode)
        
        let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.5)
        labelNode.runAction(fadeInAction)


    }
    
    func removeCancelDemoNode() {
        if let node = childNodeWithName("cancelNode") {
            let fadeOutAction = SKAction.fadeAlphaTo(0, duration: 0.3)
            node.runAction(fadeOutAction, completion: { () -> Void in
                node.removeFromParent()
            })
        }
    }
    
    func addLabelNode(text: String, textInterval: NSTimeInterval, taskInterval: NSTimeInterval, taskBlock: (Void)->Void, completion: (Void)->Void) {
        let labelNode = NORLabelNode(fontNamed:"Chalkduster")
        labelNode.text = text
        labelNode.fontSize = 20
        labelNode.horizontalAlignmentMode = .Center
        labelNode.verticalAlignmentMode = .Center
        labelNode.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        labelNode.alpha = 0
        self.addChild(labelNode)
        
        let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.5)
        labelNode.runAction(fadeInAction) { () -> Void in
            
            delay(textInterval, completion: { () -> Void in
                let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.5)
                labelNode.runAction(fadeAction, completion: { () -> Void in
                    labelNode.removeFromParent()
                    
                    taskBlock()
                    
                    delay(taskInterval, completion: { () -> Void in
                        completion()
                    })
                })
            })
        }
    }
    
    func demonstrateCollision() {
     
        demoCollision()
        delay(1.0) { () -> Void in
            self.demoCollision()
            delay(1.0) { () -> Void in
                self.demoCollision()
            }
        }
    }
    
    func demoCollision() {
        let color = ZHBBNodeColor.randomColor
        
        let pointA = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        let bbA = ZHBBNode(nodeColor: color, point: pointA);
        bbA.physicsBody?.affectedByGravity = false
        bbA.xScale = ZHBBNodeSpawnScale*2
        bbA.yScale = ZHBBNodeSpawnScale*2
        let growAction = SKAction.scaleTo(ZHBBNodeFullScale, duration: 0.2)
        self.addChild(bbA)
        bbA.runAction(growAction)
        
        let randomX = arc4random_uniform(UInt32(self.frame.size.width))
        let randomY = arc4random_uniform(UInt32(self.frame.size.height))
        let pointB = CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
        let bbB = ZHBBNode(nodeColor: color, point: pointB);
        bbB.physicsBody?.affectedByGravity = false
        bbB.xScale = ZHBBNodeSpawnScale*2
        bbB.yScale = ZHBBNodeSpawnScale*2
        self.addChild(bbB)
        bbB.runAction(growAction)
        
        let moveAction = SKAction.moveTo(pointA, duration: 0.8)
        bbB.runAction(moveAction)

    }
    
    func demonstrateEnertia() { 
        
        
        demoEnertia()
        delay(1.0) { () -> Void in
            self.demoEnertia()
            delay(1.0) { () -> Void in
                self.demoEnertia()
                delay(1.0) { () -> Void in
                    self.demoEnertia()
                }
            }
        }
    }
    
    func demoEnertia() {
        let tapScale = CGFloat(2.0)
        let handNode = SKSpriteNode(imageNamed: "hand")
        handNode.zRotation = CGFloat(M_PI_2)
        handNode.alpha = 0
        handNode.zRotation = CGFloat(M_PI + M_PI)
        self.addChild(handNode)
        handNode.xScale = tapScale
        handNode.yScale = tapScale
        
        
        let random = arc4random_uniform(UInt32(self.children.count))
        if let bb = self.children[Int(random)] as? ZHBBNode {
            let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
            let sizeAction = SKAction.scaleTo(1.0, duration: 0.2)
            let action = SKAction.group([fadeInAction, sizeAction])
            handNode.position = bb.position
            handNode.runAction(action, completion: { () -> Void in
                let fadeOutAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
                let scaleUpAction = SKAction.scaleTo(tapScale, duration: 0.2)
                let action = SKAction.group([fadeOutAction, scaleUpAction])
                handNode.runAction(action, completion: { () -> Void in
                    handNode.removeFromParent()
                })
                bb.applyInertia()
            })
        }
    }
    
    func demonstrateGravity() {
        
        motion.stopDeviceMotionUpdates()
        
        delay(0.2) { () -> Void in
            let interval = NSTimeInterval(3.0)
            
            // Add arrow and apply gravity in that direction
            let arrowNode = SKSpriteNode(imageNamed: "arrow")
            arrowNode.zRotation = CGFloat(M_PI_2)
            arrowNode.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            arrowNode.alpha = 0
            arrowNode.zPosition = 0
            self.addChild(arrowNode)
            let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.3)
            arrowNode.runAction(fadeInAction)
            self.physicsWorld.gravity = CGVectorMake(0.0, 1.0)
            
            delay(interval) { () -> Void in
                
                let rotateAction = SKAction.rotateByAngle(CGFloat(-M_PI_2), duration: 0.3)
                arrowNode.runAction(rotateAction)
                
                self.physicsWorld.gravity = CGVectorMake(1.0, 0.0)
                
                delay(interval, completion: { () -> Void in
                    self.setupGravity()
                    arrowNode.removeFromParent()
                })
            }
        }
    }
    
    func demonstrateTaps() {

        
        let handNode = SKSpriteNode(imageNamed: "hand")
        handNode.zRotation = CGFloat(M_PI_2)
        
        var startX = CGRectGetMidX(self.frame)
        startX -= self.frame.size.width / 4.0
        var startY = CGRectGetMidY(self.frame)
        startY -= self.frame.size.height / 4.0
        let startPoint = CGPoint(x: startX, y: startY)
        startX += self.frame.size.width / 2.0
        startY += self.frame.size.height / 2.0
        let endPoint = CGPoint(x: startX, y: startY)
        
        handNode.position = startPoint
        handNode.alpha = 0
        handNode.zRotation = CGFloat(M_PI + M_PI)
        self.addChild(handNode)
        let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: 0.3)
        handNode.runAction(fadeInAction) { () -> Void in
            let moveAction = SKAction.moveTo(endPoint, duration: 2.0)
            handNode.runAction(moveAction) { () -> Void in
                
            }
            
            // Run for 2 seconds
            self.addBBAtPoint(handNode.position)
            
            for x in 0..<20 {
                delay(NSTimeInterval(x) * 0.1, completion: { () -> Void in
                    self.addBBAtPoint(handNode.position)
                })
            }
            
            delay(2.0) { () -> Void in
                let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.3)
                handNode.runAction(fadeAction, completion: { () -> Void in
                    handNode.removeFromParent()
                })
            }
        }
    }
    
    func addNodesByTimer() {
        
        NSTimer.scheduledTimerWithTimeInterval(0.25, block: { () -> Void in
            
            let randomX = arc4random_uniform(UInt32(self.frame.size.width))
            let randomY = arc4random_uniform(UInt32(self.frame.size.height))
            self.addBBAtPoint(CGPoint(x: CGFloat(randomX), y: CGFloat(randomY)))
            }, repeats: true)

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        removeCancelDemoNode()


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
            addBBAtPoint(point)
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
    
    func addBBAtPoint(point: CGPoint) {
        
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
        sprite.xScale = ZHBBNodeSpawnScale
        sprite.yScale = ZHBBNodeSpawnScale
        
        // Random rotation
        var randomZ = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) // 0.0 - 1.0
        randomZ -= 0.5  // -0.5 - 0.5
        randomZ *= 2    // -1.0 - 1.0
        randomZ *= CGFloat(M_PI)
        sprite.zRotation = randomZ
        
        let growAction = SKAction.scaleTo(ZHBBNodeFullScale, duration: 0.2)
        self.addChild(sprite)
        sprite.runAction(growAction)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        clear()
    }
}


extension ZHGameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == contact.bodyB.contactTestBitMask {
            let bodyA = contact.bodyA.node as! ZHBBNode
            let bodyB = contact.bodyB.node as! ZHBBNode
            if bodyA.physicsBody!.contactTestBitMask == bodyB.physicsBody!.contactTestBitMask {
//                bodyA.remove({ () -> Void in
//                    
//                })
//                bodyB.remove({ () -> Void in
//                    
//                })
            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}