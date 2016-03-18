//
//  ZHGameModel.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/12/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHGameModel: NSObject {

    static let sharedInstance = ZHGameModel()
    
    var tap = ZHShapeNodeTapBehavior.TapMomentum
    var collide = ZHShapesCollide.Remove
    override init() {
        
    }
    // Shapes (count, outline)
    
    // Node Touch (pop, force, drag)
    // * ZHShapeNodeTapBehavior
    
    // Node collision (force, clear, grow/shrink, teleport, static)
    
    // Fixtures (canned, gesture based, off)
    
    // Scren gestures (clear, quit)
    
    
}
