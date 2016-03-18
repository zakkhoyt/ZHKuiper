//
//  AppDelegate.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 1/1/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setupAppearance() {
        
        let smallFont = UIFont(name: "Chalkduster", size: 14)
        let mediumFont = UIFont(name: "Chalkduster", size: 20)
        let largeFont = UIFont(name: "Chalkduster", size: 28)
        
        let smallAttr = [NSForegroundColorAttributeName: UIColor.zhTintColor(),
            NSFontAttributeName: smallFont!]
        let mediumAttr = [NSForegroundColorAttributeName: UIColor.zhTintColor(),
            NSFontAttributeName: mediumFont!]

        let largeAttr = [NSForegroundColorAttributeName: UIColor.zhTintColor(),
            NSFontAttributeName: largeFont!]

        UINavigationBar.appearance().titleTextAttributes = mediumAttr
        UINavigationBar.appearance().barTintColor = UIColor.clearColor()
        UINavigationBar.appearance().tintColor = UIColor.zhTintColor()
        UIBarButtonItem.appearance().setTitleTextAttributes(mediumAttr, forState: UIControlState.Normal)
        
        UIToolbar.appearance().barTintColor = UIColor.zhBackgroundColor()
        UIToolbar.appearance().tintColor = UIColor.zhTintColor()
        
        UITableViewCell.appearance().backgroundColor = UIColor.zhBackgroundColor()
        UITableView.appearance().backgroundColor = UIColor.zhBackgroundColor()
        
        UILabel.appearance().font = mediumFont
        UILabel.appearance().textColor = UIColor.zhTintColor()
        
        
        UISegmentedControl.appearance().tintColor = UIColor.zhTintColor()
        UISegmentedControl.appearance().setTitleTextAttributes(smallAttr, forState: UIControlState.Normal)
    }


}

