//
//  ZHOptoinsMenuTableViewController.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/13/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHOptoinsMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = false
    }
    
    
    // MARK: IBActions
    
    @IBAction func shapeSegmentValueChanged(sender: AnyObject) {
    }

    @IBAction func touchSegmentValueChanged(sender: UISegmentedControl) {
        
        let value = sender.selectedSegmentIndex
        if let behavior = ZHShapeNodeTapBehavior(rawValue: UInt(value)) {
            ZHGameModel.sharedInstance.tap = behavior
        }
    }

    @IBAction func collideSegmentValueChanged(sender: AnyObject) {
        let value = sender.selectedSegmentIndex
        if let behavior = ZHShapesCollide(rawValue: UInt(value)) {
            ZHGameModel.sharedInstance.collide = behavior
        }

    }

    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
