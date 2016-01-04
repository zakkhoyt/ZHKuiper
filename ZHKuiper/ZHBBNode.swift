//
//  ZHBBNode.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit

enum ZHBBNodeColor: UInt {
    case Black = 0
    case Blue = 1
    case Brown = 2
    case Cyan = 3
    case Green = 10
    case Magenta = 4
    case Orange = 5
    case Purple = 6
    case Red = 7
    case White = 8
    case Yellow = 9
    
    static var randomColor: ZHBBNodeColor {
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
        return color
    }
    
    var imageNameFromBBColor: String {
        var name = ""
        switch self {
        case .Black:
            name = "black"
        case .Blue:
            name = "blue"
        case .Brown:
            name = "brown"
        case .Cyan:
            name = "cyan"
        case .Green:
            name = "green"
        case .Magenta:
            name = "magenta"
        case .Orange:
            name = "orange"
        case .Purple:
            name = "purple"
        case .Red:
            name = "red"
        case .White:
            name = "white"
        case .Yellow:
            name = "yellow"
        }
        return name
    }
    
    var contactBitMask: UInt32 {
        var mask: UInt32 = 0
        switch self {
        case .Black:
            mask = 1 << 1
        case .Blue:
            mask = 1 << 2
        case .Brown:
            mask = 1 << 3
        case .Cyan:
            mask = 1 << 4
        case .Green:
            mask = 1 << 5
        case .Magenta:
            mask = 1 << 6
        case .Orange:
            mask = 1 << 7
        case .Purple:
            mask = 1 << 8
        case .Red:
            mask = 1 << 9
        case .White:
            mask = 1 << 10
        case .Yellow:
            mask = 1 << 11
        }
        return mask
    }
}


class ZHBBNode: SKSpriteNode {

    var seconds = UInt(20)
    var bbColor: ZHBBNodeColor = ZHBBNodeColor.randomColor {
        didSet{
            // Set image, bbcolor, collision
        }
    }
    
    convenience init(nodeColor: ZHBBNodeColor, point: CGPoint) {
        
        self.init(imageNamed: nodeColor.imageNameFromBBColor)
        self.bbColor = nodeColor
        self.userInteractionEnabled = true
        self.xScale = 4.1
        self.yScale = 4.1
        self.color = UIColor.greenColor()
        self.position = point
        self.name = "bb"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = nodeColor.contactBitMask
        
        let soundAction = SKAction.playSoundFileNamed("drip.wav", waitForCompletion: false)
        self.runAction(soundAction)
        
        
//        let timerLabel = SKLabelNode(fontNamed:"Chalkduster")
//        timerLabel.horizontalAlignmentMode = .Center
//        timerLabel.verticalAlignmentMode = .Center
//        timerLabel.text = "\(UInt(seconds))"
//        timerLabel.fontSize = 20
//        self.addChild(timerLabel)
//
//
//        NSTimer.scheduledTimerWithTimeInterval(1.0, block: { () -> Void in
//            
//            if self.seconds == 0 {
//                timerLabel.text = "X"
//            } else {
//                self.seconds--
//                timerLabel.text = "\(self.seconds)"
//            }
//        }, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let push = SKAction.moveByX(-100, y: 100, duration: 0.3)
//        runAction(push) { () -> Void in
//            
//        }
//        self.physicsBody?.velocity = CGVectorMake(1000, 1000)
        
        
        
        if let gravity = self.scene?.physicsWorld.gravity {
            self.physicsBody?.velocity = CGVectorMake(1000 * -gravity.dx, 1000 * -gravity.dy)
        }
    }
    
    func remove(completion:(Void)->Void) {
//        NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"PKSpark" ofType:@"sks"];
//        SKEmitterNode *sparkEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
        
        let path = NSBundle.mainBundle().pathForResource("ZHSpark", ofType: "sks")
        if let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? SKNode {
            emitter.position = self.position
            self.parent?.addChild(emitter)
            
            

            let emitterFadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.5)
            emitter.runAction(emitterFadeAction) { () -> Void in
                emitter.removeFromParent()
            }
        }
    
        
        
        
        //let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        let fadeAction = SKAction.scaleTo(0.2, duration: 0.2)
        self.runAction(fadeAction) { () -> Void in
            self.removeFromParent()
            completion()
        }

        let soundAction = SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false)
        self.runAction(soundAction)
        
        
    }
}
