//
//  QuestionModel.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

enum QuestionModel: JSONDecodable {
    //    case selector
    case checkbox(_ item: CheckboxGroupModel)
    case selector(_ item: SelectorGroupModel)
    case textField(_ item: InputGroupModel)
    case textArea(_ item: InputGroupModel)
    case rating(_ item: InputGroupModel)
    
    init(json: JSON) throws {
        switch json["kind"].stringValue {
        case "checkbox":
            self = .checkbox(try CheckboxGroupModel(json: json))
        case "radio":
            self = .selector(try SelectorGroupModel(json: json))
        case "text_input":
            self = .textField(try InputGroupModel(json: json))
        case "text_area":
            self = .textArea(try InputGroupModel(json: json))
        case "rating":
            self = .rating(try InputGroupModel(json: json))
        default:
            throw NError.iniciativeFull
        }
    }
}

typealias QuestionVM = (UIView, PublishSubject<AnswerRequest>)

extension QuestionModel {
    
    func getView() -> QuestionVM {
        var vm: QuestionVM
        var title: String
        switch self {
        case .checkbox(let item):
            vm = getCheckbox(item: item)
            title = item.title
            case .selector(let item):
                vm = getSelector(item: item)
                title = item.title
                case .textField(let item):
                    vm = getTextField(item: item)
                    title = item.title
                    case .textArea(let item):
                        vm = getTextArea(item: item)
                        title = item.title
                        case .rating(let item):
                            vm = getTextField(item: item)
                            title = item.title
        }
        let section = SectionView(title: title, view: vm.0)
        return (section, vm.1)
    }
    
    func getCheckbox(item: CheckboxGroupModel) -> QuestionVM {
        let table = CheckboxGroupView(model: item)
        return (table, table.answerRequestSubject)
    }
    
    func getSelector(item: SelectorGroupModel) -> QuestionVM {
        let table = SelectorGroupView(model: item)
        return (table, table.answerRequestSubject)
    }
    
    func getTextField(item: InputGroupModel) -> QuestionVM {
        let field = QuestionTextField(model: item)
        return (field, field.subject)
    }
    
    func getTextArea(item: InputGroupModel) -> QuestionVM {
        let field = QuestionTextArea(model: item)
        return (field, field.subject)
    }
    
}
