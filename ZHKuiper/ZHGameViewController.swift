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
    
    @IBOutlet weak var menuView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZHGameModel.sharedInstance

        reset()
        
        NSNotificationCenter.defaultCenter().addObserverForName(ZHNotificationStart, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            self.hideMenu()
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(ZHNotificationQuit, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            self.reset()
        }

        
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
    
    private func reset() {
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        
        let startScene = ZHStartScene(size: view.bounds.size)
        startScene.scaleMode = .ResizeFill
        startScene.startHandler = {
            let gameScene = ZHGameScene(size: self.view.bounds.size)
            gameScene.scaleMode = .ResizeFill
            let transition = SKTransition.doorwayWithDuration(1.0)
            skView.presentScene(gameScene, transition: transition)
        }
        
        skView.presentScene(startScene)

        view.bringSubviewToFront(menuView)
    }
    
    private func hideMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.alpha = 0
            }) { (animated) -> Void in
                self.menuView.hidden = true
        }
    }
    
    private func showMenu() {
        self.menuView.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.alpha = 1.0
            }) { (animated) -> Void in
                
        }
    }

}
