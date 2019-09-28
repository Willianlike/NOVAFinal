//
//  AnswerRequest.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct AnswerRequest {
    let questionOrderNum: String
    let choices: [String]
    let input: String?
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["questionOrderNum"] = Int(questionOrderNum)
        params["choices"] = choices.map({ Int($0) })
        params["input"] = input
        return params
    }
}
