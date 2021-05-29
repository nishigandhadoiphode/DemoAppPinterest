//
//  PinterestImageModel.swift
//  PinterestDemoApp
//
//  Created by Nishigandha on 23/05/21.
//  Copyright © 2021 Nishigandha. All rights reserved.
//

import UIKit
import Kingfisher


struct PinterestImageModel {
    var username: String
    var likes: String
    var image: UIImage?
    var imageUrl: String
    var isLikedByUser: Bool
    

    init(username: String, likes: String, image: UIImage,imageUrl: String , isLikedByUser: Bool) {
    self.username = username
    self.likes = likes
    self.image = image
        self.imageUrl = imageUrl
    self.isLikedByUser = isLikedByUser
  }

    init?(feed: PinterestFeed, downloadedImage:UIImage) {
        guard
            let username:String = feed.user.name,
            let likes:Int = feed.likes,
            let imageUrl:String = feed.urls.small,
            let isLikedByUser = feed.liked_by_user
          else {
            return nil
        }
        
        self.init(username: username, likes: String(likes), image: downloadedImage, imageUrl: imageUrl, isLikedByUser:isLikedByUser)
      }
    
}



