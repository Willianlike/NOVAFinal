//
//  ForgotPasswordVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography
import PKHUD

class ForgotPasswordVC: BaseVC {
    
    let provider = ApiProvider.shared
    
    let phoneView = UIStackView()
    
    let phoneField = PhoneField()
    let phoneInfo = UILabel()
    let phoneBtn = UIButton(type: .system)
    
    let requestForgot = PublishSubject<String>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        let text = NSMutableAttributedString(string: "Восстановление пароля",
                                             attributes: [NSAttributedString.Key.font : UIFont.b1(.bold)])
        
        topView.title.attributedText = text
        
        view.backgroundColor = .white
        
        phoneView.addArrangedSubview(phoneInfo)
        phoneView.addArrangedSubview(phoneField)
        phoneView.addArrangedSubview(phoneBtn)
        
        phoneView.alignment = .center
        phoneView.axis = .vertical
        phoneView.distribution = .equalSpacing
        phoneView.spacing = 16
        
        
        phoneBtn.setTitle("Запросить новый пароль", for: .normal)
        phoneBtn.setTitleColor(.white, for: .normal)
        phoneBtn.layer.cornerRadius = 52 / 2
        phoneBtn.clipsToBounds = true
        phoneBtn.titleLabel?.font = .b2(.bold)
        phoneBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        
        phoneField.placeholder = "Номер телефона"
        phoneField.font = .b2()
        phoneField.backgroundColor = .white
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        
        setEqualW(phoneView, views: phoneField, phoneBtn, phoneInfo)
        
        constrain(phoneField, phoneBtn, phoneInfo)
        { (phoneField, phoneBtn, phoneInfo) in
            phoneField.height == 52
            phoneBtn.height == 52
        }
        
        scrollContainer.addSubview(phoneView)
        
        constrain(phoneView, scrollContainer) { (phoneView, container) in
            phoneView.top == container.top + 30
            phoneView.leading == container.leading + 24
            phoneView.trailing == container.trailing - 24
            phoneView.bottom <= container.bottom
            
        }
        
            requestForgot.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
                HUD.show(.progress)
            }).disposed(by: disposeBag)
        
        requestForgot.asObservable().flatMap({ [unowned self] in self.provider.passRecover(phone: $0) })
            .subscribe(onNext: { [unowned self] result in
                HUD.hide()
                switch result {
                case .success(let bol):
                    if bol.success {
                        HUD.flash(.label("Мы выслалий новый пароль на номер \(self.phoneField.text!)"), delay: 3, completion: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        HUD.flash(.label(NError.forgot.localizedDescription), delay: 1)
                    }
                case .failure(let err):
                    HUD.flash(.label(err.localizedDescription), delay: 1)
                }
            }).disposed(by: disposeBag)
        
        phoneBtn.rx.tap
            .map { [unowned self] _ in
                return self.phoneField.text
        }
        .filter { !$0.isNilOrEmpty }
        .map({ $0! })
        .bind(to: requestForgot).disposed(by: disposeBag)
        
        
    }
    
}
