//
//  RegisterVC.swift
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

enum ProfileKind: String {
    case person, expert, business
    var localize: String {
        switch self {
        case .person:
            return "Физические лицо"
        case .expert:
            return "Юридическое лицо"
        case .business:
            return "Эксперт"
        }
    }
}

class RegisterVC: BaseVC {
    
    enum RegStyle {
        case code
        case fields
    }
    
    let provider = ApiProvider.shared
    
    
    let regStyle = BehaviorRelay<RegStyle>(value: .code)
    
    let phoneView = UIStackView()
    let fieldsView = UIStackView()
    
    let phoneField = PhoneField()
    let phoneBtn = UIButton(type: .system)
    
    let codeField = RegField()
    let kindButton = UIButton(type: .system)
    let passfield = RegField()
    let regBtn = UIButton(type: .system)
    
    var regKind = BehaviorRelay<ProfileKind>(value: .person)
    let requestCode = PublishSubject<String>()
    let requestReg = PublishSubject<RegRequest>()
    let requestAuth = PublishSubject<LoginRequest>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        let text = NSMutableAttributedString(string: "Регистрация",
                                             attributes: [NSAttributedString.Key.font : UIFont.b1(.bold)])
        
        topView.title.attributedText = text
        
        view.backgroundColor = .white
        
        phoneView.addArrangedSubview(phoneField)
        phoneView.addArrangedSubview(phoneBtn)
        
        fieldsView.addArrangedSubview(codeField)
        fieldsView.addArrangedSubview(kindButton)
        fieldsView.addArrangedSubview(passfield)
        fieldsView.addArrangedSubview(regBtn)
        fieldsView.isHidden = true
        
        fieldsView.alignment = .center
        fieldsView.axis = .vertical
        fieldsView.distribution = .equalSpacing
        fieldsView.spacing = 16
        
        phoneView.alignment = .center
        phoneView.axis = .vertical
        phoneView.distribution = .equalSpacing
        phoneView.spacing = 16
        
        
        phoneBtn.setTitle("Отправить", for: .normal)
        phoneBtn.setTitleColor(.white, for: .normal)
        phoneBtn.layer.cornerRadius = 52 / 2
        phoneBtn.clipsToBounds = true
        phoneBtn.titleLabel?.font = .b2(.bold)
        phoneBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        regBtn.setTitle("Зарегистрироваться", for: .normal)
        regBtn.setTitleColor(.white, for: .normal)
        regBtn.layer.cornerRadius = 52 / 2
        regBtn.clipsToBounds = true
        regBtn.titleLabel?.font = .b2(.bold)
        regBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        kindButton.setTitleColor(.white, for: .normal)
        kindButton.layer.cornerRadius = 52 / 2
        kindButton.clipsToBounds = true
        kindButton.titleLabel?.font = .b2(.bold)
        kindButton.setBackgroundImage(Images.barBack, for: .normal)
        
        
        phoneField.placeholder = "Номер телефона"
        phoneField.font = .b2()
        phoneField.backgroundColor = .white
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        
        codeField.placeholder = "Код из смс"
        codeField.font = .b2()
        codeField.backgroundColor = .white
        codeField.returnKeyType = .next
        codeField.keyboardType = .numberPad
        
        passfield.placeholder = "Пароль"
        passfield.font = .b2()
        passfield.backgroundColor = .white
        passfield.isSecureTextEntry = true
        passfield.returnKeyType = .next
        
        setEqualW(fieldsView, views: codeField, kindButton, passfield, regBtn)
        setEqualW(phoneView, views: phoneField, phoneBtn)
        
        constrain(codeField, kindButton, passfield, phoneField, phoneBtn, regBtn)
        { (codeField, kindButton, passfield, phoneField, phoneBtn, regBtn) in
            codeField.height == 52
            kindButton.height == 52
            passfield.height == 52
            phoneField.height == 52
            phoneBtn.height == 52
            regBtn.height == 52
        }
        
        scrollContainer.addSubview(phoneView)
        scrollContainer.addSubview(fieldsView)
        
        constrain(fieldsView, phoneView, scrollContainer) { (fieldsView, phoneView, container) in
            fieldsView.top == container.top + 30
            fieldsView.leading == container.leading + 24
            fieldsView.trailing == container.trailing - 24
            fieldsView.bottom <= container.bottom
            
            phoneView.top == container.top + 30
            phoneView.leading == container.leading + 24
            phoneView.trailing == container.trailing - 24
            phoneView.bottom <= container.bottom
            
//            fieldsView.height == 52 * 4 + 16 * 3
//            phoneView.height == 52 * 2 + 16
            
        }
        
        Observable.of(requestReg.asObservable().map({ _ in Void()}),
            requestCode.asObservable().map({ _ in Void()})).merge()
            .subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
                HUD.show(.progress)
            }).disposed(by: disposeBag)
        
        requestReg.asObservable().flatMap({ [unowned self] in self.provider.reg(request: $0) })
            .subscribe(onNext: { [unowned self] result in
                HUD.hide()
                switch result {
                case .success(let bol):
                    if bol.success {
//                        let requestAuth = LoginRequest(login: "+79995709730",
//                                                       pass: "qweqwe")
                        
                        let requestAuth = LoginRequest(login: self.phoneField.text,
                                                       pass: self.passfield.text)
                        self.requestAuth.onNext(requestAuth)
                    } else {
                        HUD.flash(.label(NError.reg.localizedDescription), delay: 1)
                    }
                case .failure(let err):
                    HUD.flash(.label(err.localizedDescription), delay: 1)
                }
            }).disposed(by: disposeBag)
        
        requestCode.asObservable().flatMap({ [unowned self] in self.provider.sendCode(phone: $0) })
            .subscribe(onNext: { [unowned self] result in
                HUD.hide()
                switch result {
                case .success(let bol):
                    if bol.success {
                        self.regStyle.accept(.fields)
                        self.codeField.becomeFirstResponder()
                    } else {
                        HUD.flash(.label(NError.reg.localizedDescription), delay: 1)
                    }
                case .failure(let err):
                    HUD.flash(.label(err.localizedDescription), delay: 1)
                }
            }).disposed(by: disposeBag)
        
        requestAuth.asObservable().flatMap({ [unowned self] in self.provider.auth(request: $0) })
            .subscribe(onNext: { [unowned self] result in
                HUD.hide()
                switch result {
                case .success(let bol):
                    profileKind = bol.kind
                    UserDefaults.standard.authToken = bol.token
                    self.successAuth()
                case .failure(let err):
                    HUD.flash(.label(err.localizedDescription), delay: 1)
                }
            }).disposed(by: disposeBag)
        
        
        
        regStyle.subscribe(onNext: { [unowned self] style in
            switch style {
            case .code:
                self.phoneView.isHidden = false
                self.fieldsView.isHidden = true
            case .fields:
                self.phoneView.isHidden = true
                self.fieldsView.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        
        
        
        
        regKind.map({ "Тип аккаунта " + $0.localize }).bind(to: kindButton.rx.title()).disposed(by: disposeBag)
        kindButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.showKinds()
        }).disposed(by: disposeBag)
        
        phoneBtn.rx.tap
            .map { [unowned self] _ in
                return self.phoneField.text
        }
        .filter { !$0.isNilOrEmpty }
        .map({ $0! })
        .bind(to: requestCode).disposed(by: disposeBag)
        
        regBtn.rx.tap
            .map { [unowned self] _ -> RegRequest? in
                if let code = self.codeField.text,
                    let pass = self.passfield.text {
                    return RegRequest(pass: pass, kind: self.regKind.value, code: code)
                }
                return nil
        }
        .filter { $0 != nil }
        .map({ $0! })
        .bind(to: requestReg).disposed(by: disposeBag)
        
    }
    
    func successAuth() {
        let vc = MainTabBar.getTabBar()
        //        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showKinds() {
        let alert = UIAlertController(title: "Выберите тип аккаунта", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ProfileKind.person.localize, style: .default,
                                      handler: { (_) in
                                        self.regKind.accept(.person)
        }))
        alert.addAction(UIAlertAction(title: ProfileKind.business.localize, style: .default,
                                      handler: { (_) in
                                        self.regKind.accept(.business)
        }))
        alert.addAction(UIAlertAction(title: ProfileKind.expert.localize, style: .default,
                                      handler: { (_) in
                                        self.regKind.accept(.expert)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
