//
//  PinterestAPICalls.swift
//  PinterestDemoApp
//
//  Created by Nishigandha on 23/05/21.
//  Copyright © 2021 Nishigandha. All rights reserved.
//

import UIKit
import Alamofire

class PinterestAPICalls: NSObject
{
    
    //MARK: - Class functions
    
    class func getPinterestFeeds(_ completionHandler:@escaping (Bool, [PinterestFeed]?,AFError?) -> (Void))
    {
        let reqURL: String = "https://pastebin.com/raw/wgkJgazE"
        PinterestAPIManager.jsonRequest(reqURL, { isSuccess, pinterestFeeds, error in
            
            if isSuccess {
                print(pinterestFeeds)
                completionHandler(true,pinterestFeeds,nil)
            }else {
                completionHandler(false,nil,error)
            }
        })
    }
}
