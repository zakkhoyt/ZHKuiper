//
//  ZHUtilities.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/9/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation


func delay(interval: NSTimeInterval, completion: (Void)->Void) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64( interval * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
        completion()
    }
}
