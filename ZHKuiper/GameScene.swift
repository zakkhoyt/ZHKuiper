//
//  GameScene.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright (c) 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit
import CoreMotion


let kMaxBBCount = 100

class GameScene: SKScene {
    
    var motion = CMMotionManager()
    var blockNode: SKShapeNode? = nil
    var point1: CGPoint = CGPointZero
    var point2: CGPoint = CGPointZero
    var ref = CGPathCreateMutable()
    
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
//                        print("gravity")
                        self.physicsWorld.gravity = CGVectorMake(CGFloat(x), CGFloat(y))
                    })
                }
            }
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapGestureRecognizer.numberOfTapsRequired = 4
        self.view?.addGestureRecognizer(tapGestureRecognizer)
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:");
//        self.view?.addGestureRecognizer(panGestureRecognizer);
        
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Kuiper!"
        myLabel.fontSize = 72
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        myLabel.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        myLabel.physicsBody?.dynamic = true
        myLabel.physicsBody?.affectedByGravity = true
        
        
        self.addChild(myLabel)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, block: { () -> Void in
            self.addSpriteAtPoint(CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height - 30))
            }, repeats: true)
        
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
            point2 = touch.locationInNode(self)
            if let blockNode = blockNode {
                
                ref = CGPathCreateMutable()
                CGPathMoveToPoint(ref, nil, point1.x, point1.y)
                CGPathAddLineToPoint(ref, nil, point2.x, point2.y)
                blockNode.path = ref
                blockNode.physicsBody = SKPhysicsBody(edgeLoopFromPath: ref)
            } else {

                blockNode = SKShapeNode()
                CGPathMoveToPoint(ref, nil, point1.x, point1.y)
                CGPathAddLineToPoint(ref, nil, point2.x, point2.y)
                blockNode!.path = ref
                blockNode!.lineWidth = 20
                blockNode?.lineCap = .Round
                blockNode!.fillColor = UIColor.whiteColor()
                blockNode!.strokeColor = UIColor.whiteColor()
                blockNode!.physicsBody = SKPhysicsBody(edgeLoopFromPath: ref)
                blockNode!.physicsBody!.dynamic = true
                blockNode!.physicsBody!.affectedByGravity = false
                self.addChild(blockNode!)
            }
        }

    }
    
    func addSpriteAtPoint(point: CGPoint) {
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

        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        self.addChild(sprite)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        for child in self.children {
            child.runAction(fadeAction, completion: { () -> Void in
                child.removeFromParent()
            })
        }
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            self.bbs.removeAll()
//        }
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
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
}