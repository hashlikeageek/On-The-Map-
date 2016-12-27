//
//  udacityClient.swift
//  On The Map
//
//  Created by Ashutosh Kumar Sai on 21/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation

class udacityClient : NSObject {

     var userKey = ""
    var firstName = ""
    var lastName = ""

    //this function will get the session Key and make sure we log in after logging in we will get the account key so that we can get First and last name 
    func login (_ username : String, password: String, completionHandler: @escaping (_ success: Bool, _ _title: String,_ _message: String,_ dismiss: String) -> Void)
    {
      

        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let response = response as? HTTPURLResponse {
                            if response.statusCode < 200 || response.statusCode > 300 {
                                
                                DispatchQueue.main.async()
                                    {
                                        print("In the error of udacity client")
                                   completionHandler(false, "Error","Something went wrong with Parse", "Try Again")
                                        return
                                }
                                    }
                                }
                
                DispatchQueue.main.async()
                {
                    print("loginWithInput - \(error!.localizedDescription)")
                    
                    completionHandler(false,"Connection Error","Could not connect to internet. Please Try Again","Try Again")
                    
                }
               
            }
            else
            {
            let newData = data!.subdata(in: 5..<(data!.count))
            print(newData)
            
            let parsedData = (try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
                
                print(parsedData)
            
            if let accountData = parsedData["account"] as? [String: AnyObject]
            {
             if let keyData = accountData["key"] as? String
            {
                self.userKey = keyData
                 print(keyData)
                }
            }
                
            else
            {
                DispatchQueue.main.async(){
               completionHandler(false,"Invalid Credential","Username or Password is invalid. Please Try Again","Try Again")}
            }
           completionHandler(true, "success", "", "")
            }
        }
        print("At the end of login")
        task.resume()
        print("Going out bro")
    }
    
    
    //now we try to get the users Public data using the accountkey that we have obtained through the login method 
    func publicData(_ completionHandler: @escaping (_ success: Bool, _ _title: String,_ _message: String,_ dismiss: String) -> Void){
        
        print("Entered in public data")
        
       let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/\(self.userKey)")! as URL)
        print("got past requesst")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { print("in error")
                return
            }
           let newData = data!.subdata(in: 5..<(data!.count))
            print("got past data")
           
            let parsedData = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
            print("got past parsedData")
          
            if let firstName = (parsedData["user"] as? [String: Any])?["first_name"] as? String {
                self.firstName = firstName
            } else {
                completionHandler(false, "Error", "Could not get the first name", "Retry")
                return
            }
            
            //Get the last name.
            if let lastName = (parsedData["user"] as? [String: Any])?["last_name"] as? String {
                self.lastName = lastName
            } else {
                completionHandler(false, "Error", "Could not get the last name", "Retry")
                return
            }

            print(parsedData)
            completionHandler(true, "success", "", "")
            
        }
        task.resume()
    }
    
//we will use this client for logging out of the application 
        func logOut(_ completionHandler: @escaping (_ success: Bool, _ _title: String,_ _message: String,_ dismiss: String) -> Void)
        {
            print("In log out")
           
            let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async(){
                        completionHandler(false,"Invalid Credential","Could Not Log Out Try Again","Try Again")}
                }
                let range = Range(uncheckedBounds: (5, data!.count - 5))
                let newData = data?.subdata(in: range) /* subset response data! */
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                completionHandler(true, "success", "", "")
            }
            task.resume()
            
    }
    
    
    class func sharedInstance() -> udacityClient {
        struct Singleton {
            static var sharedInstance = udacityClient()
        }
        return Singleton.sharedInstance
    }
    
  


    
}
