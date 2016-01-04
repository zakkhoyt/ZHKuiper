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
    
    func nameFromColor(color: ZHBBNodeColor) -> String {
        var name = ""
        switch color {
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
    
    func contactBitMask(color: ZHBBNodeColor) -> UInt32 {
        var mask: UInt32 = 0
        switch color {
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

    
    convenience init(nodeColor: ZHBBNodeColor, point: CGPoint) {
        let name = nodeColor.nameFromColor(nodeColor)
        self.init(imageNamed: name)
        
        self.xScale = 4.1
        self.yScale = 4.1
        self.color = UIColor.greenColor()
        self.position = point
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = nodeColor.contactBitMask(nodeColor)
        
        let soundAction = SKAction.playSoundFileNamed("drip.wav", waitForCompletion: false)
        self.runAction(soundAction)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let push = SKAction.moveByX(-100, y: 100, duration: 0.3)
        runAction(push) { () -> Void in
            
        }
    }
    
    func remove() {
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
        }

        let soundAction = SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false)
        self.runAction(soundAction)
        
        
    }
}
