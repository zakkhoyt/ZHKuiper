//
//  ZHBBNode.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import SpriteKit

let ZHBBNodeFullScale = CGFloat(2.0)
let ZHBBNodeDragScale = CGFloat(3.0)
let ZHBBNodeSpawnScale = CGFloat(0.1)

enum ZHBBNodeColor: UInt {
    case Black = 0
    case Blue = 1
    case Brown = 2
    case Cyan = 3
    case Green = 4
    case Magenta = 5
    case Orange = 6
    case Purple = 7
    case Red = 8
    case White = 9
    case Yellow = 10
    case BlackPoly = 11
    case BluePoly = 12
    case BrownPoly = 13
    case CyanPoly = 14
    case GreenPoly = 15
    case MagentaPoly = 16
    case OrangePoly = 17
    case PurplePoly = 18
    case RedPoly = 19
    case WhitePoly = 20
    case YellowPoly = 21
    case BlackStar = 22
    case BlueStar = 23
    case BrownStar = 24
    case CyanStar = 25
    case GreenStar = 26
    case MagentaStar = 27
    case OrangeStar = 28
    case PurpleStar = 29
    case RedStar = 30
    case WhiteStar = 31
    case YellowStar = 32

    
    static var randomColor: ZHBBNodeColor {
        let random = arc4random_uniform(32)
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
        case 11:
            color = .BlackPoly
        case 12:
            color = .BluePoly
        case 13:
            color = .BrownPoly
        case 14:
            color = .CyanPoly
        case 15:
            color = .GreenPoly
        case 16:
            color = .MagentaPoly
        case 17:
            color = .OrangePoly
        case 18:
            color = .PurplePoly
        case 19:
            color = .RedPoly
        case 20:
            color = .WhitePoly
        case 21:
            color = .YellowPoly
        case 22:
            color = .BlackStar
        case 23:
            color = .BlueStar
        case 24:
            color = .BrownStar
        case 25:
            color = .CyanStar
        case 26:
            color = .GreenStar
        case 27:
            color = .MagentaStar
        case 28:
            color = .OrangeStar
        case 29:
            color = .PurpleStar
        case 30:
            color = .RedStar
        case 31:
            color = .WhiteStar
        case 32:
            color = .YellowStar
            
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
        case .BlackPoly:
            name = "black_poly"
        case .BluePoly:
            name = "blue_poly"
        case .BrownPoly:
            name = "brown_poly"
        case .CyanPoly:
            name = "cyan_poly"
        case .GreenPoly:
            name = "green_poly"
        case .MagentaPoly:
            name = "magenta_poly"
        case .OrangePoly:
            name = "orange_poly"
        case .PurplePoly:
            name = "purple_poly"
        case .RedPoly:
            name = "red_poly"
        case .WhitePoly:
            name = "white_poly"
        case .YellowPoly:
            name = "yellow_poly"
        case .BlackStar:
            name = "black_star"
        case .BlueStar:
            name = "blue_star"
        case .BrownStar:
            name = "brown_star"
        case .CyanStar:
            name = "cyan_star"
        case .GreenStar:
            name = "green_star"
        case .MagentaStar:
            name = "magenta_star"
        case .OrangeStar:
            name = "orange_star"
        case .PurpleStar:
            name = "purple_star"
        case .RedStar:
            name = "red_star"
        case .WhiteStar:
            name = "white_star"
        case .YellowStar:
            name = "yellow_star"
        }
        return name
    }
    
    var contactBitMask: UInt32 {
        var mask: UInt32 = 0
        switch self {
        case .Black:
            mask = 1 << 0
        case .Blue:
            mask = 1 << 1
        case .Brown:
            mask = 1 << 2
        case .Cyan:
            mask = 1 << 3
        case .Green:
            mask = 1 << 4
        case .Magenta:
            mask = 1 << 5
        case .Orange:
            mask = 1 << 6
        case .Purple:
            mask = 1 << 7
        case .Red:
            mask = 1 << 8
        case .White:
            mask = 1 << 9
        case .Yellow:
            mask = 1 << 10
        case .BlackPoly:
            mask = 1 << 11
        case .BluePoly:
            mask = 1 << 12
        case .BrownPoly:
            mask = 1 << 13
        case .CyanPoly:
            mask = 1 << 14
        case .GreenPoly:
            mask = 1 << 15
        case .MagentaPoly:
            mask = 1 << 16
        case .OrangePoly:
            mask = 1 << 17
        case .PurplePoly:
            mask = 1 << 18
        case .RedPoly:
            mask = 1 << 29
        case .WhitePoly:
            mask = 1 << 20
        case .YellowPoly:
            mask = 1 << 21
        case .BlackStar:
            mask = 1 << 22
        case .BlueStar:
            mask = 1 << 23
        case .BrownStar:
            mask = 1 << 24
        case .CyanStar:
            mask = 1 << 25
        case .GreenStar:
            mask = 1 << 26
        case .MagentaStar:
            mask = 1 << 27
        case .OrangeStar:
            mask = 1 << 28
        case .PurpleStar:
            mask = 1 << 29
        case .RedStar:
            mask = 1 << 30
        case .WhiteStar:
            mask = 1 << 31
        case .YellowStar:
            mask =  1 << 21
        }
        return mask
    }
}

enum ZHBBNodeBehavior: UInt {
    case TapMomentum = 0
    case TapDrag = 1
}

enum ZHBBNodeSound: String {
    case Pew = "pew.wav"
    case Drip = "drip.wav"
}

class ZHBBNode: SKSpriteNode {
    let behavior = ZHBBNodeBehavior.TapMomentum
    var seconds = UInt(20)
    var previousPoint = CGPointZero
    
    var bbColor: ZHBBNodeColor = ZHBBNodeColor.randomColor {
        didSet{
            // Set image, bbcolor, collision
        }
    }
    
    convenience init(nodeColor: ZHBBNodeColor, point: CGPoint) {
        
        self.init(imageNamed: nodeColor.imageNameFromBBColor)
        self.bbColor = nodeColor
        self.userInteractionEnabled = true
        self.xScale = ZHBBNodeFullScale
        self.yScale = ZHBBNodeFullScale
        self.color = UIColor.greenColor()
        self.position = point
        self.name = "bb"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.contactTestBitMask = nodeColor.contactBitMask
        
        let soundAction = SKAction.playSoundFileNamed(ZHBBNodeSound.Drip.rawValue, waitForCompletion: false)
        self.runAction(soundAction)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch behavior {
        case .TapMomentum:
            if let gravity = self.scene?.physicsWorld.gravity {
                let factor = CGFloat(1000)
                
                if -gravity.dx < 1.0 && -gravity.dy < 1.0 {
                    
                    // make a random vector of some strength
                    var randomX = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) // 0.0 - 1.0
                    randomX -= 0.5  // -0.5 - 0.5
                    randomX *= 2    // -1.0 - 1.0
                    randomX *= factor
                    randomX *= 3
                    
                    var randomY = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                    randomY -= 0.5
                    randomY *= 2
                    randomY *= factor
                    randomY *= 3
                
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
        case .TapDrag:
            
            let hoverAction = SKAction.scaleTo(ZHBBNodeDragScale, duration: 0.2)
            let alphaAction = SKAction.fadeAlphaTo(0.7, duration: 0.2)
            let action = SKAction.group([hoverAction, alphaAction])
            self.runAction(action)
            
            physicsBody?.dynamic = false
            updatePosition(touches, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch behavior {
        case .TapMomentum:
            return
        case .TapDrag:
            updatePosition(touches, withEvent: event)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch behavior {
        case .TapMomentum:
            return
        case .TapDrag:
            updatePosition(touches, withEvent: event)
            physicsBody?.dynamic = true
            
            let hoverAction = SKAction.scaleTo(ZHBBNodeFullScale, duration: 0.2)
            let alphaAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
            let action = SKAction.group([hoverAction, alphaAction])
            self.runAction(action)

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
    
    func remove(completion:(Void)->Void) {
        let path = NSBundle.mainBundle().pathForResource("ZHMagic", ofType: "sks")
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
