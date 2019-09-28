//
//  IniciativeCommentsResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct IniciativeCommentsResponse: JSONDecodable {
    
    var comments: [DiscussionModel]
    
    init(json: JSON) throws {
        comments = json["comments"].arrayValue
            .compactMap({ try? DiscussionModel(json: $0) })
    }
    
}
