//
//  PinterestAPIManager.swift
//  PinterestDemoApp
//
//  Created by Nishigandha on 23/05/21.
//  Copyright © 2021 Nishigandha. All rights reserved.
//

import UIKit
import Alamofire

class PinterestAPIManager: NSObject {
    
    class func jsonRequest(_ requestURL:String,_ completionHandler:@escaping (Bool,[PinterestFeed]?,AFError?) -> (Void))
    {
        
        AF.request(requestURL,
                   method: .get)
            .responseDecodable(of:[PinterestFeed].self) { response in
                switch response.result {
                case .success:
                    switch response.response?.statusCode {
                    case 200:
                        completionHandler(true,response.value,nil)
                        break
                        
                    default:
                        //handle other cases
                        break
                    }
                case let .failure(error):
                    completionHandler(false,nil,error)
                    break
                }
            }
    }
    
    
}
