//
//  parseClient.swift
//  On The Map
//
//  Created by Ashutosh Kumar Sai on 21/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import Foundation

class parseClient : NSObject
{
    // this contains all the data that we will need to display on the pin
    
    
    // we use this method to repopulate the student data
    func  getData(_ completionHandler: @escaping (_ success: Bool, _ title: String,_ message: String,_ dismiss: String) -> Void)
    {
        
        print("I am in getData parse")
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        print("Got past request thing")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        print("Did add both the values")
        let session = URLSession.shared
        print("Created a session")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
           
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode > 300 {
                  DispatchQueue.main.async()
                    {
                        completionHandler(false, "Error","Something went wrong with Parse", "Try Again")
                        return
                    }
                    
                }
            }
            
            
            
            if error != nil {
                
                DispatchQueue.main.async()
                    {
                completionHandler(false, "Error","Something went wrong with Parse", "Try Again")
                return
                }
            }
            else
            {
                print("Got in else of getdata")
                let parsingError: NSError? = nil
                let parsedData = try? JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String: AnyObject]
                print("did get parsed data")
                
                if let error = parsingError {
                    DispatchQueue.main.async()
                        {
                    completionHandler(false, error.description,"","")
                    }
                }
                else {
                
                
                if let results = parsedData?["results"] as? [[String : AnyObject]] {
                    
                    print("in results thing")
                    
                    modelClass.point.removeAll(keepingCapacity: true)
                    print("removed")
                    
                    for result in results {
                        print("in loop damn you")
                        modelClass.point.append(StudentData(dictionary: result))
                        print("Appended somehow")
                    }
                    print("out of loop")
                }
                else
                {
                    DispatchQueue.main.async()
                        {
                    completionHandler(false,"Error","Something went wrong with Parse", "Try Again")
                    }
                }
                }
            }
            DispatchQueue.main.async()
                {
            completionHandler(true, "success", "", "")
            }

        }
        task.resume()

    }
    
    
    // this method is used in order to submit new data to parse
    func submitData(_ latitude: String, longitude: String, addressField: String, link: String, completionHandler: @escaping (_ success: Bool, _ error: String) -> Void)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(udacityClient.sharedInstance().userKey)\", \"firstName\": \"\(udacityClient.sharedInstance().firstName)\", \"lastName\": \"\(udacityClient.sharedInstance().lastName)\",\"mapString\": \"\(addressField)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode > 300 {
                     DispatchQueue.main.async()
                        {
                    completionHandler(false, "Error")
                    return
                    }
                }
            }
            
            if error != nil {
                DispatchQueue.main.async()
                    {
                completionHandler(false, "Failed to submit data.")
                }
            } else {
                DispatchQueue.main.async()
                    {
                completionHandler(true, "nil")
                }
            }
            
        }) 
        task.resume()
    }
    
    
    //single instatance
    class func sharedInstance() -> parseClient {
        struct Singleton {
            static var sharedInstance = parseClient()
        }
        return Singleton.sharedInstance
    }

}
