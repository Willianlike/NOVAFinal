//
//  CheckboxGroupModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CheckboxGroupModel: JSONDecodable {
    
    let id: String
    let title: String
    var items: [CheckboxItemModel]
    
    init(json: JSON) throws {
        print(json)
        id = try json[ConstantsIniciative.questionId].reqString()
        title = try json[ConstantsIniciative.questionTitle].reqString()
        items = json[ConstantsIniciative.questionAnswers].arrayValue.compactMap({ try? CheckboxItemModel(json: $0) })
    }
    
    func toRequest() -> Any {
        return ""
    }
    
    mutating func didTapped(index: Int) {
        guard items.indices.contains(index) else { return }
        items[index].selected = !items[index].selected
    }
    
    func buildRequest() -> AnswerRequest {
        let coices = items.compactMap { (model) -> String? in
            if model.selected {
                return model.id
            }
            return nil
        }
        return AnswerRequest(questionOrderNum: id, choices: coices, input: nil)
    }
    
}
