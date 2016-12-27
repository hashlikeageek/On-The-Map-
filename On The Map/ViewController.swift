//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ashutosh Kumar Sai on 20/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var errorHandler: UILabel!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    func handleError(_ title: String, message: String, dismiss: String)
    {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "\(dismiss)", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        login.isEnabled = true
        errorHandler.text = "Enter Valid Data"
        
    }

    
    @IBAction func signUpAction(_ sender: Any) {
        if let signupURL = URL(string: "https://auth.udacity.com/sign-up?next=https://in.udacity.com/")
        {
            UIApplication.shared.openURL(signupURL)
        }
    }
    @IBAction func logInAction(_ sender: Any) {
        //lets check basic errors in entries
        login.isEnabled = false
        errorHandler.text = "Hold On"
        
        if userName.text == "" ,passWord.text == ""
        {
        handleError("Error", message: "You can not leave password or username empty", dismiss: "Retry")
        }
        
        udacityClient.sharedInstance().login(userName.text!,password: passWord.text!){ (success,title,message , dismiss )
            in
            
            print("i am in loginaction")
            
            if success
            {
                udacityClient.sharedInstance().publicData({ (success, title, message, dismiss) in
                    
                    if success
                        
                    {
                        parseClient.sharedInstance().getData({ (sucess,title, message, dismiss ) in
                            if success
                            {
                                self.completeLogin()
                            }
                            else
                            {
                                self.handleError("Error", message: "Could Not Complete Login", dismiss: "Retry")
                            }
                        })
                    }
                    else
                    {
                     self.handleError("Error", message: "Could Not get data from Udatcity", dismiss: "Retry")
                    }
                })
            }
            else
            {
                self.handleError(title, message: "\(message)", dismiss: "\(dismiss)")
            }
        }
        
        
    //step 1 - fetch UserKey from Udacity - done
        //if it goes through  than fetch student data
            // call complete login method
        //otherwise return error
        
    }
    
    
    func completeLogin()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabNav")
        
        present(controller!, animated: true, completion: nil)
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.userName.delegate = self
         self.passWord.delegate = self
        
        
      
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
        return false
    }
}

