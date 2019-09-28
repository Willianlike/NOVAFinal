//
//  SendCommentRequest.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct SendCommentRequest {
    
    let id: String
    let replyTo: Int?
    let text: String
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["initiativeId"] = Int(id)
        params["replyTo"] = replyTo
        params["text"] = text
        return params
    }
    
}
