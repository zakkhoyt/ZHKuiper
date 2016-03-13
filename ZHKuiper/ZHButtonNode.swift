//
//  ZHButtonNode.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/12/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHButtonNode: SKLabelNode {

    class func button(text: String, point: CGPoint, handler: ((Void)->Void)!) -> ZHButtonNode {
        let button = ZHButtonNode(handler: handler)
        button.name = text
        button.fontName = "Chalkduster"
        button.text = text
        button.fontSize = 20
        button.horizontalAlignmentMode = .Center
        button.verticalAlignmentMode = .Center
        button.position = point
        button.fontColor = UIColor.greenColor()
        button.userInteractionEnabled = true
        return button
    }

    private var handler:((Void)->Void)!
    
    init(handler: ((Void)->Void)!) {
        super.init()
        self.handler = handler
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let duration = NSTimeInterval(0.15)
        let fadeOut = SKAction.fadeAlphaTo(0.2, duration: duration)

        self.runAction(fadeOut) { () -> Void in
            if self.handler != nil {
                self.handler()
            }

        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
            self.runAction(fadeIn)
        }
        
    }
    
}
