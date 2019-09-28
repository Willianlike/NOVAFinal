//
//  IniciativeCommentsRequest.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct IniciativeCommentsRequest {
    let id: String
    let offset: Int = 0
    let limit: Int = 100
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["initiativeId"] = Int(id)
        params["offset"] = offset
        params["limit"] = limit
        return params
    }
}
