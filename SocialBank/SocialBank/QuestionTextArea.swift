//
//  QuestionTextArea.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class QuestionTextArea: UIView {
    
    let textView = UITextView()
    
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<AnswerRequest>()
    
    var model: InputGroupModel
    
    init(model: InputGroupModel) {
        self.model = model
        super.init(frame: CGRect())
        addBorders(edges: .all)
        
        addSubview(textView)
        backgroundColor = .ultraLight
        textView.backgroundColor = .ultraLight
        
        constrain(self, textView) { (view, textView) in
            textView.edges == inset(view.edges, 8, 13, 8, 13)
            view.height == 120
        }
        if !model.input.isNilOrEmpty {
            textView.text = model.input
        }
        textView.font = .b2()
        textView.textColor = .primaryText
        
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        
        textView.rx.text.changed
            .throttle(ConstantsIniciative.throttle, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] text in
                self.model.input = text
                self.subject.onNext(self.model.buildRequest())
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
