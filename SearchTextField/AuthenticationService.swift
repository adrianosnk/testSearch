//
//  AuthenticationService.swift
//  
//
//  Created by MacAdrian on 10/4/21.
//  Copyright © 2021 Siri. All rights reserved.
//

import Foundation

import SearchTextField

class AuthenticationService {
    let URL_BASE:String = "http://www.nactem.ac.uk"
  
    func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
           let url = URL(string: "\(URL_BASE)/software/acromine/dictionary.py?sf=\(criteria)")
           
           if let url = url {
               let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                   do {
                       if let data = data {
                           let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
                           
                           if let firstElement = jsonData.first {
                               let jsonResults = firstElement["lfs"] as! [[String: AnyObject]]
                               
                               var results = [SearchTextFieldItem]()
                               
                               for result in jsonResults {
                                   results.append(SearchTextFieldItem(title: result["lf"] as! String, subtitle: criteria.uppercased(), image: UIImage(named: "acronym_icon")))
                               }
                               
                               DispatchQueue.main.async {
                                   callback(results)
                               }
                           } else {
                               DispatchQueue.main.async {
                                   callback([])
                               }
                           }
                       } else {
                           DispatchQueue.main.async {
                               callback([])
                           }
                       }
                   }
                   catch {
                       print("Network error: \(error)")
                       DispatchQueue.main.async {
                           callback([])
                       }
                   }
               })
               
               task.resume()
           }
       }
    func createAccount(){
        
    }
    
  
    
}
extension Dictionary {
    func toJsonData()->Data?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            //            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            //            print (jsonString)
            return jsonData
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
