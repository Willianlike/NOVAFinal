//
//  LoginResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginResponse: JSONDecodable {
    var token: String
    
    init(json: JSON) throws {
        if json["success"].boolValue {
            token = try json["basic"].reqString()
        } else {
            throw NError.auth
        }
    }
    
    
}
