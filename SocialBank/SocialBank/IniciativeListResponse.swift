//
//  IniciativeListResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct IniciativeListResponse: JSONDecodable {
    
    let items: [BankIniciativeModel]
    
    init(json: JSON) throws {
        items = json["initiatives"].arrayValue.compactMap({ try? BankIniciativeModel(json: $0) })
    }
    
}
