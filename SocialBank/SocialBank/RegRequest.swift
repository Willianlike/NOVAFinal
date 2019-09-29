//
//  RegRequest.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct RegRequest {
    let pass: String
    let kind: ProfileKind
    let code: String
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["password"] = pass
        params["kind"] = kind.rawValue
        params["code"] = code
        return params
    }
}
