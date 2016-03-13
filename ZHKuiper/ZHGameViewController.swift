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

        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        
        let startScene = ZHStartScene(size: view.bounds.size)
        startScene.scaleMode = .ResizeFill
        startScene.skipHandler = {
            let gameScene = ZHGameScene(size: self.view.bounds.size)
            gameScene.scaleMode = .ResizeFill
            let transition = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            skView.presentScene(gameScene, transition: transition)
        }
        
        skView.presentScene(startScene)
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
