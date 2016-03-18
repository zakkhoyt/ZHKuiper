//
//  ZHShapeNode.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit

let ZHShapeNodeFullScale = CGFloat(1.0)
let ZHShapeNodeDragScale = CGFloat(1.5)
let ZHShapeNodeSpawnScale = CGFloat(0.05)


class ZHShapeNode: SKSpriteNode {
    
    var seconds = UInt(20)
    var previousPoint = CGPointZero
    
    var bbColor: ZHShapeNodeColor = ZHShapeNodeColor.randomColor {
        didSet{
        }
    }
    
    convenience init(nodeColor: ZHShapeNodeColor, point: CGPoint) {
        
        self.init(imageNamed: nodeColor.imageNameFromBBColor)
        self.bbColor = nodeColor
        self.userInteractionEnabled = true
        self.xScale = ZHShapeNodeFullScale
        self.yScale = ZHShapeNodeFullScale
        self.color = UIColor.greenColor()
        self.position = point
        self.name = "bb"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = nodeColor.contactBitMask
        
        playSound(.Drip)
        
        var random = arc4random_uniform(UInt32(1000)) // 0 to 999
        random /= 16 // 0 to 99.99
        let delay = NSTimeInterval(10 + random)
        NSTimer.scheduledTimerWithTimeInterval(delay, block: { () -> Void in
            self.remove(.Shrink, completion: { () -> Void in
                
            })
            }, repeats: true)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch ZHGameModel.sharedInstance.tap {
        case .TapMomentum:
            applyInertia()
        case .TapDrag:
            
            let hoverAction = SKAction.scaleTo(ZHShapeNodeDragScale, duration: 0.2)
            let alphaAction = SKAction.fadeAlphaTo(0.7, duration: 0.2)
            let action = SKAction.group([hoverAction, alphaAction])
            self.runAction(action)
            
            physicsBody?.dynamic = false
            updatePosition(touches, withEvent: event)
        case .TapRemove:
            remove(.Grow, completion: { () -> Void in
            })
        case .TapTeleport:
            teleport()
        case .TapSticky:
            toggleSticky()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch ZHGameModel.sharedInstance.tap {
        case .TapMomentum:
            return
        case .TapDrag:
            updatePosition(touches, withEvent: event)
        case .TapRemove:
            return
        case .TapTeleport:
            return
        case .TapSticky:
            return
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch ZHGameModel.sharedInstance.tap {
        case .TapMomentum:
            return
        case .TapDrag:
            updatePosition(touches, withEvent: event)
            physicsBody?.dynamic = true
            
            let hoverAction = SKAction.scaleTo(ZHShapeNodeFullScale, duration: 0.2)
            let alphaAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
            let action = SKAction.group([hoverAction, alphaAction])
            self.runAction(action)
        case .TapRemove:
            return
        case .TapTeleport:
            return
        case .TapSticky:
            return
        }
        
    }
    
    func teleport() {
        
        if let frame = self.parent?.frame {
        
            let point = self.position
            var x = frame.size.width - point.x
            var y = frame.size.height - point.y
            
            let deltaX = CGFloat(arc4random_uniform(UInt32(50)))
            let deltaY = CGFloat(arc4random_uniform(UInt32(50)))
//            
//            x += deltaX
//            y += deltaY
            
            
            let newPoint = CGPoint(x: x, y: y)
            
            playSound(.Teleport)
            let duration = NSTimeInterval(0.3)
            let fadeOutAction = SKAction.fadeAlphaTo(0.0, duration: duration)
            let shrinkAction = SKAction.scaleTo(0.1, duration: duration)
            let outAction = SKAction.group([fadeOutAction, shrinkAction])
            self.runAction(outAction, completion: { () -> Void in
                self.position = newPoint
                let fadeInAction = SKAction.fadeAlphaTo(1.0, duration: duration)
                let growAction = SKAction.scaleTo(1.0, duration: duration)
                let inAction = SKAction.group([fadeInAction, growAction])
                self.runAction(inAction, completion: { () -> Void in
                })
            })
        }
    }
    
    
    func toggleSticky() {
     
        playSound(.Sticky)
        if let physicsBody = self.physicsBody {
            if physicsBody.dynamic {
                physicsBody.dynamic = false
                
                let shrinkAction = SKAction.scaleTo(0.9, duration: 0.1)
                let growAction = SKAction.scaleTo((1.1), duration: 0.1)
                let vibrateAction = SKAction.sequence([shrinkAction, growAction])
                let repeatAction = SKAction.repeatActionForever(vibrateAction)
                self.runAction(SKAction.sequence([repeatAction]), withKey: "vibrate")


            } else {
                physicsBody.dynamic = true
                self.removeActionForKey("vibrate");
            }

        }
        
        

        
    }
    
    
    func updatePosition(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if let parent = parent {
                let point = touch.locationInNode(parent)
                self.position = point
            }
        }
    }
    
    func applyInertia() {
        if let gravity = self.scene?.physicsWorld.gravity {
            
            playSound(.Laser)
            
            let factor = CGFloat(1000)
            
            if -gravity.dx < 1.0 && -gravity.dy < 1.0 {
                
                // make a random vector of some strength
                var randomX = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) // 0.0 - 1.0
                randomX -= 0.5  // -0.5 - 0.5
                randomX *= 2    // -1.0 - 1.0
                randomX *= factor
                randomX *= 2
                
                var randomY = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                randomY -= 0.5
                randomY *= 2
                randomY *= factor
                randomY *= 2
                
                print("rgravity: \(randomX)x\(randomY)")
                self.physicsBody?.velocity = CGVectorMake(randomX, randomY)
            } else {
                var x = -gravity.dx
                x *= factor
                var y = -gravity.dy
                y *= factor
                
                print("gravity: \(x)x\(y)")
                self.physicsBody?.velocity = CGVectorMake(x, y)
            }
            
        }
    }
    
    
    
    func remove(type: ZHShapeNodeRemoveType, completion:(Void)->Void) {
        let path = NSBundle.mainBundle().pathForResource("ZHMagic", ofType: "sks")
        if let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? SKNode {
            emitter.position = self.position
            emitter.physicsBody?.affectedByGravity = true
            emitter.physicsBody?.dynamic = true
            self.parent?.addChild(emitter)
            
            let emitterFadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.5)
            emitter.runAction(emitterFadeAction) { () -> Void in
                emitter.removeFromParent()
            }
        }
        
        
        //let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        if ZHGameModel.sharedInstance.tap == .TapRemove {
            
            switch type {
            case .Grow:
                let scale = SKAction.scaleTo(10.0, duration: 0.2)
                let fade = SKAction.fadeAlphaTo(0.1, duration: 0.2)
                let action = SKAction.group([scale, fade])
                self.runAction(action) { () -> Void in
                    self.removeFromParent()
                    completion()
                }
                
                playSound(.Pop2)
                
            case .Shrink:
                let scale = SKAction.scaleTo(0.1, duration: 0.2)
                let fade = SKAction.fadeAlphaTo(0.1, duration: 0.2)
                let action = SKAction.group([scale, fade])
                self.runAction(action) { () -> Void in
                    self.removeFromParent()
                    completion()
                }
                
                playSound(.Pop1)
                
            }
            
        } else {
            let fadeAction = SKAction.scaleTo(0.2, duration: 0.2)
            self.runAction(fadeAction) { () -> Void in
                self.removeFromParent()
                completion()
            }
            
            playSound(.Pew)
        }
    }
    
    func playSound(sound: ZHShapeNodeSound) {
        let soundAction = SKAction.playSoundFileNamed(sound.rawValue, waitForCompletion: true)
        self.runAction(soundAction)
        //        SKTAudio.sharedInstance().playSoundEffect(sound.rawValue)
    }
}
