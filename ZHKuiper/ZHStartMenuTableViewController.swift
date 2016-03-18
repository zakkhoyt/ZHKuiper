//
//  ZHStartMenuTableViewController.swift
//  ZHKuiper
//
//  Created by Zakk Hoyt on 3/13/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHStartMenuTableViewController: UITableViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            NSNotificationCenter.defaultCenter().postNotificationName(ZHNotificationDemo, object: nil)
        case 1:
            ()
        case 2:
            NSNotificationCenter.defaultCenter().postNotificationName(ZHNotificationStart, object: nil)
        default:
            ()
        }
    }
}
