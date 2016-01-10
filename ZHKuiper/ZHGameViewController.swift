//
//  ZHGameViewController.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright (c) 2016 Zakk Hoyt. All rights reserved.
//

import UIKit
import SpriteKit

class ZHGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let scene = ZHGameScene(fileNamed:"ZHGameScene") {
//            // Configure the view.
//            let skView = self.view as! SKView
////            skView.showsFPS = true
////            skView.showsNodeCount = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//            
//            skView.presentScene(scene)
//        }
        
        
        let scene = ZHGameScene(size: view.bounds.size)
        
        //scene.frame = view.bounds
        scene.backgroundColor = UIColor.darkGrayColor()
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
        
        skView.presentScene(scene)
        
        
        
        
        
//        if let scene = ZHGameScene(fileNamed:"ZHGameScene") {
//            // Configure the view.
//            let skView = self.view as! SKView
//            //            skView.showsFPS = true
//            //            skView.showsNodeCount = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//            
//            skView.presentScene(scene)
//        }

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
