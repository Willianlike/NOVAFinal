//
//  IniciativeFullResponse.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct IniciativeFullResponse: JSONDecodable {
    
    var questions: [QuestionModel]
    
    init(json: JSON) throws {
        questions = json["questions"].arrayValue
            .compactMap({ try? QuestionModel(json: $0) })
    }
    
}
