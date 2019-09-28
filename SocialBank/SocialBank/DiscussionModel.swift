//
//  DiscussionModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DiscussionModel: JSONDecodable {
    
    let id: Int
    let img: String
    let name: String
    let isOnline: Bool
    let date: Date
    let comment: String
    var replyTo: Bool = false
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    init(json: JSON) throws {
        img = json["avatar"].stringValue
        id = try json["id"].reqInt()
        name = try json["nickname"].reqString()
        comment = try json["text"].reqString()
        isOnline = json["i"].boolValue
        date = Date(timeIntervalSince1970: TimeInterval(try json["ts"].reqInt()))
        
    }
    
}
