//
//  QuestionTextField.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class QuestionTextField: UITextField {
    
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<AnswerRequest>()
    
    var model: InputGroupModel
    
    init(model: InputGroupModel) {
        self.model = model
        super.init(frame: CGRect())
        addBorders(edges: .all)
        constrain(self) { (view) in
            view.height == 52
        }
        if !model.input.isNilOrEmpty {
            text = model.input
        }
        
        font = .b2()
        textColor = .primaryText
        
        rx.text.changed
            .throttle(ConstantsIniciative.throttle, scheduler: MainScheduler.asyncInstance)
//        .debounce(1, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] text in
                self.model.input = text
                self.subject.onNext(self.model.buildRequest())
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return getBounds(for: super.textRect(forBounds: bounds))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return getBounds(for: super.placeholderRect(forBounds: bounds))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getBounds(for: super.editingRect(forBounds: bounds))
    }
    
    private func getBounds(for bounds: CGRect) -> CGRect {
        var b = bounds
        b.origin.x += 16
        b.size.width -= 32
        return b
    }
    
}
