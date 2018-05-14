//
//  SettingsTableViewController.swift
//  AR-Photoday
//
//  Created by CCH on 14/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section, idx = indexPath.row
        tableView.deselectRow(at: indexPath, animated: false)
        switch(section) {
        case 0:
            switch(idx) {
            case 1:
                let urlString = "https://github.com/ivankwongtszfung/AR-Photoday/README.md"
                let url = URL(string : urlString)!
                UIApplication.shared.open(url, options: [:])
                break
            default:
                break
            }
            break
        default:
            break
        }
    }

}
