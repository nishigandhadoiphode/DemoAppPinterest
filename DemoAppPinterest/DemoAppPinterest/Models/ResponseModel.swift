//
//  JSON.swift
//  PinterestDemoApp
//
//  Created by Nishigandha on 23/05/21.
//  Copyright © 2021 Nishigandha. All rights reserved.
//

import UIKit

struct PinterestFeed:Codable {
    let likes: Int!
    let liked_by_user: Bool!
    let user: User!
    let urls: URLS!
}

struct User:Codable {
    let name: String!
}

struct URLS:Codable {
    let small: String!
    let thumb: String!
    let full: String!
    let regular: String!
    let raw: String!
}
