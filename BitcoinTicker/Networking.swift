//
//  Networking.swift
//  BitcoinTicker
//
//  Created by Giulio Gola on 11/04/2019.
//

import UIKit
import Alamofire
import SwiftyJSON

class Networking {
    
    // Get data from url with Alamofire -> returns optional json object
    func getData(url: String, completion: @escaping((JSON?)->())) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let resultJSON = JSON(response.result.value!)
                completion(resultJSON)
            }
            else {
                print("Error: \(String(describing: response.result.error))")
                completion(nil)
            }
        }
    }
    
}

