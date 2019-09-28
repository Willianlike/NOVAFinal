//
//  CheckboxItemModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CheckboxItemModel: JSONDecodable {
    
    var title: String
    let id: String
    var selected: Bool
    
    init(json: JSON) throws {
        title = try json[ConstantsIniciative.answerTitle].reqString()
        id = try json[ConstantsIniciative.answerId].reqString()
        selected = json[ConstantsIniciative.answerSelected].boolValue
    }
    
}
