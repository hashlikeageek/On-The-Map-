//
//  tabViewController.swift
//  On The Map
//
//  Created by Ashutosh Kumar Sai on 22/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation
import UIKit

class tabViewController : UITabBarController
{
    
    func handleError(_ title: String, message: String, dismiss: String)
    {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "\(dismiss)", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parseClient.sharedInstance().getData({ (sucess,title, message, dismiss ) in
            if sucess
            {
                print("Did reload your data")
            }
            else
            {
                self.handleError("Error", message: "Could Not Get Data From Parse Server", dismiss: "Dismiss")
            }
        })

    }
    
    
    @IBAction func logOutAction(_ sender: Any) {
        udacityClient.sharedInstance().logOut({ (success, title, message, dismiss)
            in
            
            if success
            {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "logIn")
                self.present(controller!, animated: true, completion: nil)
                
            }
            else
            {
                self.handleError("Error", message: "Could Not LogOut", dismiss: "Retry")
                
            }
    }
    )}
}
