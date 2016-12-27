//
//  tableViewController.swift
//  On The Map
//
//  Created by Ashutosh Kumar Sai on 21/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation
import UIKit

class tableViewController : UITableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "reuseMe"
        let newpoint = modelClass.point[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        cell!.textLabel!.text = newpoint.fullName
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelClass.point.count
    }
    
    
    //Opens the mediaURL in Safari when a table cell is tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(URL(string: modelClass.point[(indexPath as NSIndexPath).row].mediaURL)!)
    }
  
    }
