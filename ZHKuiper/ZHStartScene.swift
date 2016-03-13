//
//  ZHStartScene.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/12/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

//let ZHGameSceneMaxDemoCount = UInt(5)

class ZHStartScene: ZHGameScene {

    
    // MARK: Public methods
    
    var skipHandler:((Void)->Void)!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        showLabels()
    }
    
    // MARK: Override methods
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        skip()
    }
    
    internal override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        skip()
    }
    
    internal override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        skip()
    }

    private func skip() {
        if skipHandler != nil {
            skipHandler()
        }
    }
    
    private func showLabels() {
        
        
        let textInterval = NSTimeInterval(2.0)
        let taskInterval = NSTimeInterval(3.0)
        let totalInterval = textInterval + taskInterval
        
        let skipLabelNode = NORLabelNode(fontNamed:"Chalkduster")
        skipLabelNode.text = "Tap anwhere to skip"
        skipLabelNode.fontSize = 14
        skipLabelNode.horizontalAlignmentMode = .Center
        skipLabelNode.verticalAlignmentMode = .Center
        skipLabelNode.position = CGPoint(x:CGRectGetMidX(self.frame), y:76)
//        skipLabelNode.alpha = 1
        self.addChild(skipLabelNode)
        
        
        
        
        
        delay(0 * totalInterval) { () -> Void in
            self.addLabelNode("Tap & drag to\nspawn shapes", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                self.demonstrateTaps()
                }) { () -> Void in
            }
        }
        
        delay(1 * totalInterval) { () -> Void in
            self.addLabelNode("Use gravity by\ntilting the device", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                self.demonstrateGravity()
                }) { () -> Void in
            }
            
        }

        delay(2 * totalInterval) { () -> Void in
            self.addLabelNode("Tap shapes to\nto make them pop", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                self.demonstrateEnertia()
                }) { () -> Void in
            }
            
        }
        
        delay(3 * totalInterval) { () -> Void in
            self.addLabelNode("Double tap with\ntwo fingers to clear\nthe screen", textInterval: textInterval, taskInterval: 0, taskBlock: { () -> Void in
                super.clear()
                }) { () -> Void in
            }
        
        }
        
        delay(4 * totalInterval) { () -> Void in
            self.addLabelNode("Have fun!", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
                }) { () -> Void in
            }
        }
//        
//        addLabelNode("Tap & drag to\nspawn shapes", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
//            //            self.addCancelDemoNode()
//            self.demonstrateTaps()
//            }) { () -> Void in
//                self.addLabelNode("Use gravity by\ntilting the device", textInterval: textInterval, taskInterval: 6.0, taskBlock: { () -> Void in
//                    //                    self.removeCancelDemoNode()
//                    self.demonstrateGravity()
//                    }) { () -> Void in
//                        //                        self.addLabelNode("When matching shapes\ntouch they disappear", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
//                        //                            self.demonstrateCollision()
//                        //                            }) { () -> Void in
//                        self.addLabelNode("Tap shapes to\nto make them pop", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
//                            self.demonstrateEnertia()
//                            }) { () -> Void in
//                                self.addLabelNode("Double tap with\ntwo fingers to clear\nthe screen", textInterval: textInterval, taskInterval: 0, taskBlock: { () -> Void in
//                                    super.clear()
//                                    }) { () -> Void in
//                                        self.addLabelNode("Have fun!", textInterval: textInterval, taskInterval: taskInterval, taskBlock: { () -> Void in
//                                            }) { () -> Void in
//                                        }
//                                }
//                        }
//                        //                        }
//                }
//        }
        
    }
    
    private func addLabelNode(text: String, textInterval: NSTimeInterval, taskInterval: NSTimeInterval, taskBlock: (Void)->Void, completion: (Void)->Void) {
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
    
    private func demonstrateCollision() {
        
        demoCollision()
        delay(1.0) { () -> Void in
            self.demoCollision()
            delay(1.0) { () -> Void in
                self.demoCollision()
            }
        }
    }
    
    private func demoCollision() {
        let color = ZHShapeNodeColor.randomColor
        
        let pointA = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        let bbA = ZHShapeNode(nodeColor: color, point: pointA);
        bbA.physicsBody?.affectedByGravity = false
        bbA.xScale = ZHShapeNodeSpawnScale*2
        bbA.yScale = ZHShapeNodeSpawnScale*2
        let growAction = SKAction.scaleTo(ZHShapeNodeFullScale, duration: 0.2)
        self.addChild(bbA)
        bbA.runAction(growAction)
        
        let randomX = arc4random_uniform(UInt32(self.frame.size.width))
        let randomY = arc4random_uniform(UInt32(self.frame.size.height))
        let pointB = CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
        let bbB = ZHShapeNode(nodeColor: color, point: pointB);
        bbB.physicsBody?.affectedByGravity = false
        bbB.xScale = ZHShapeNodeSpawnScale*2
        bbB.yScale = ZHShapeNodeSpawnScale*2
        self.addChild(bbB)
        bbB.runAction(growAction)
        
        let moveAction = SKAction.moveTo(pointA, duration: 0.8)
        bbB.runAction(moveAction)
        
    }
    
    private func demonstrateEnertia() {
        
        
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
    
    private func demoEnertia() {
        let tapScale = CGFloat(2.0)
        let handNode = SKSpriteNode(imageNamed: "hand")
        handNode.zRotation = CGFloat(M_PI_2)
        handNode.alpha = 0
        handNode.zRotation = CGFloat(M_PI + M_PI)
        self.addChild(handNode)
        handNode.xScale = tapScale
        handNode.yScale = tapScale
        
        
        let random = arc4random_uniform(UInt32(self.children.count))
        if let bb = self.children[Int(random)] as? ZHShapeNode {
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
                //                bb.applyInertia()
                bb.remove(.Grow, completion: { () -> Void in
                    
                })
            })
        }
    }
    
    private func demonstrateGravity() {
        
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
            
//            delay(interval) { () -> Void in
//                
//                let rotateAction = SKAction.rotateByAngle(CGFloat(-M_PI_2), duration: 0.3)
//                arrowNode.runAction(rotateAction)
//                
//                self.physicsWorld.gravity = CGVectorMake(1.0, 0.0)
            
                delay(interval, completion: { () -> Void in
                    self.setupGravity()
                    arrowNode.removeFromParent()
                })
//            }
        }
    }
    
    private func demonstrateTaps() {
        
        
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
            self.addBBAtPoint(handNode.position, scale: 1.0)
            
            for x in 0..<20 {
                delay(NSTimeInterval(x) * 0.1, completion: { () -> Void in
                    self.addBBAtPoint(handNode.position, scale: 1.0)
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


}

