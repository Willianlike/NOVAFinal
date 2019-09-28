//
//  QuestionRating.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class QuestionRating: UIView {
    
    let stack = UIStackView()
    var buttons = [UIButton]()
    
    var modelRx: BehaviorRelay<InputGroupModel>
    
    let subject = PublishSubject<AnswerRequest>()
    let starsTapped = PublishSubject<Int>()
    
    let disposeBag = DisposeBag()
    
    let emptyImg = Images.star_empty
    let selectedImg = Images.star_selected
    
    init(model: InputGroupModel) {
        self.modelRx = BehaviorRelay<InputGroupModel>(value: model)
        super.init(frame: CGRect())
        
        addSubview(stack)
        
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        constrain(stack, self) { (stack, view) in
            stack.edges == view.edges
        }
        
        let count = getCount(model.input)
        for i in 1...5 {
            let button = UIButton(type: .system)
            buttons.append(button)
            if count <= i {
                button.setImage(emptyImg, for: .normal)
            } else {
                button.setImage(selectedImg, for: .normal)
            }
            button.rx.tap.map({_ in i}).bind(to: starsTapped).disposed(by: disposeBag)
            
            stack.addArrangedSubview(button)
            constrain(button) { (btn) in
                btn.height == btn.width
                btn.height == 32
            }
        }
        
        starsTapped.asObservable()
            .withLatestFrom(modelRx) {($0, $1)}
            .map({ [unowned self] (data) in
                var model = data.1
                let count = data.0
                if count == self.getCount(model.input) {
                    model.input = "0"
                } else {
                    model.input = "\(count)"
                }
                return model
            }).bind(to: modelRx).disposed(by: disposeBag)
        
        modelRx.asObservable()
            .do(onNext: { [unowned self] model in
                let count = self.getCount(model.input)
                for i in self.buttons.indices {
                    if count <= i {
                        self.buttons[i].setImage(self.emptyImg, for: .normal)
                    } else {
                        self.buttons[i].setImage(self.selectedImg, for: .normal)
                    }
                }
            })
            .throttle(ConstantsIniciative.throttle, scheduler: MainScheduler.asyncInstance)
            .map({ $0.buildRequest() })
            .bind(to: subject)
            .disposed(by: disposeBag)
    }
    
    func getCount(_ text: String?) -> Int {
        return Int(text ?? "0") ?? 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
