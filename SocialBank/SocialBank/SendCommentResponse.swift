//
//  SendCommentResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SuccessResponse: JSONDecodable {
    
    var success: Bool
    
    init(json: JSON) throws {
        success = json["success"].boolValue
    }
    
}
