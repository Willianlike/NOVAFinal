//
//  SelectorGroupModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SelectorGroupModel: JSONDecodable {
    
    let id: String
    let title: String
    var items: [SelectorItemModel]
    
    init(json: JSON) throws {
        print(json)
        id = try json[ConstantsIniciative.questionId].reqString()
        title = try json[ConstantsIniciative.questionTitle].reqString()
        items = json[ConstantsIniciative.questionAnswers].arrayValue.compactMap({ try? SelectorItemModel(json: $0) })
    }
    
    func toRequest() -> Any {
        return ""
    }
    
    mutating func didTapped(index: Int) {
        guard items.indices.contains(index),
            !items[index].selected else { return }
        var newArr = items
        for i in newArr.indices {
            newArr[i].selected = i == index
        }
        items = newArr
    }
    
    func buildRequest() -> AnswerRequest {
        let coiced = items.first(where: { $0.selected })
        return AnswerRequest(questionOrderNum: id, choices: [coiced?.id ?? ""], input: nil)
    }
    
}
