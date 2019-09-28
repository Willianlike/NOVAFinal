//
//  InputGroupModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InputGroupModel: JSONDecodable {
    
    let id: String
    let title: String
    var input: String?
    
    init(json: JSON) throws {
        id = try json[ConstantsIniciative.questionId].reqString()
        title = try json[ConstantsIniciative.questionTitle].reqString()
        input = json[ConstantsIniciative.questionInput].string
    }
    
    func toRequest() -> Any {
        return ""
    }
    
    func buildRequest() -> AnswerRequest {
        return AnswerRequest(questionOrderNum: id, choices: [], input: input)
    }
    
}
