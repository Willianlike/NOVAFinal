//
//  BankIniciativeModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BankIniciativeModel: JSONDecodable, Equatable {
    let id: String
    let title: String
    let description: String
    let image: String?
    let video: String?
    var upvotes: Int
    var downvotes: Int
    var voteStatus: VoteStatus
    
    init(json: JSON) throws {
        id = try json["id"].reqString()
        title = try json["name"].reqString()
        description = try json["comment"].reqString()
        image = json["image_url"].string
        video = json["video_url"].string
        upvotes = try json["upvotes"].reqInt()
        downvotes = try json["downvotes"].reqInt()
        voteStatus = VoteStatus(rawValue: json["vote_status"].stringValue) ?? .none
    }
    
    static func getMock() -> String {
        return """
        {
            "id": "kek",
            "name": "111",
            "comment": "desclaburbfnkdanfefs",
            "image_url": "https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg",
            "upvotes": 123,
            "downvotes": 321
        }
        """
    }
}

func == (lhs: BankIniciativeModel, rhs: BankIniciativeModel) -> Bool {
    return lhs.id == rhs.id
}
