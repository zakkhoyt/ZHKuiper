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
    private var blockNode: SKShapeNode? = nil
    private var point1: CGPoint = CGPointZero
    private var point2: CGPoint = CGPointZero
    private var ref = CGPathCreateMutable()
    private var matchCounter: UInt = 0
    private var startTime = NSDate()
    private var masterBB: ZHShapeNode? = nil
    
    
    
    // MARK: Public methods
    
    func tap(sender: UITapGestureRecognizer) {
        clear()
    }

    
    func clear() {
        for node in self.children {
            if node.name == "bb" {
                if let bb = node as? ZHShapeNode {
                    bb.remove(.Shrink, completion: { () -> Void in
                    })
                }
            }
        }
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
    
    func addBBAtPoint(point: CGPoint, scale: CGFloat) {
        
        var counter = 0
        for node in self.children {
            if node.name == "bb" {
                counter++
            }
            if counter > kMaxBBCount {
                return
            }
        }
        
        let sprite = ZHShapeNode(nodeColor: ZHShapeNodeColor.randomColor, point: point);
        sprite.xScale = ZHShapeNodeSpawnScale
        sprite.yScale = ZHShapeNodeSpawnScale
        
        // Random rotation
        var randomZ = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) // 0.0 - 1.0
        randomZ -= 0.5  // -0.5 - 0.5
        randomZ *= 2    // -1.0 - 1.0
        randomZ *= CGFloat(M_PI)
        sprite.zRotation = randomZ
        
        let growAction = SKAction.scaleTo(ZHShapeNodeFullScale * scale, duration: 0.2)
        self.addChild(sprite)
        sprite.runAction(growAction)
    }
    
    // MARK: Override methods
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.blackColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        setupGestures()
        setupGravity()
//        showLabels()
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
        // MARK: Private methods
    
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        tapGesture.numberOfTapsRequired = 2
        tapGesture.numberOfTouchesRequired = 2
        self.view?.addGestureRecognizer(tapGesture)
    }
    

    
    
    
    private func demoRunning() -> Bool {
        if let _ = childNodeWithName("cancelNode") {
            return true
        }
        return false
    }
    
    private func addCancelDemoNode() {
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
    
    private func removeCancelDemoNode() {
        if let node = childNodeWithName("cancelNode") {
            let fadeOutAction = SKAction.fadeAlphaTo(0, duration: 0.3)
            node.runAction(fadeOutAction, completion: { () -> Void in
                node.removeFromParent()
            })
        }
    }
    
    
    private func addNodesByTimer() {
        
        NSTimer.scheduledTimerWithTimeInterval(0.25, block: { () -> Void in
            
            let randomX = arc4random_uniform(UInt32(self.frame.size.width))
            let randomY = arc4random_uniform(UInt32(self.frame.size.height))
            self.addBBAtPoint(CGPoint(x: CGFloat(randomX), y: CGFloat(randomY)), scale: 1.0)
            }, repeats: true)
        
    }
    
    
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        removeCancelDemoNode()
        
        
        for touch in touches {
            point1 = touch.locationInNode(self)
        }
        touch(touches, withEvent: event)
        
    }
    
    internal override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch(touches, withEvent: event)
    }
    
    internal override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch(touches, withEvent: event)
    }
    
    private func touch(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let point = touch.locationInNode(self)
            var force = CGFloat(1.0)
            if #available(iOS 9.0, *) {
                if touch.force > 0.01 && touch.maximumPossibleForce > 0.01 {
                    force = touch.force / touch.maximumPossibleForce
                    force += 0.5
                }
            } else {
                
            }
            print("force: \(force)")
            addBBAtPoint(point, scale: force)
        }
    }

    
    private func addMasterBB() {
        if let _ = masterBB {
            return
        }
        
        let point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - 120)
        masterBB = ZHShapeNode(nodeColor: ZHShapeNodeColor.randomColor, point: point)
        if let masterBB = masterBB {
            masterBB.userInteractionEnabled = false
            masterBB.physicsBody?.dynamic = false
            masterBB.name = "masterNode"
            masterBB.xScale = 8.0
            masterBB.yScale = 8.0
            self.addChild(masterBB)
        }
    }
    

    
}


extension ZHGameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == contact.bodyB.contactTestBitMask {
            let bodyA = contact.bodyA.node as! ZHShapeNode
            let bodyB = contact.bodyB.node as! ZHShapeNode
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