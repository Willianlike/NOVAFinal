//
//  LoginVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import RxKeyboard
import RxSwift
import RxCocoa
import RxGesture
import PKHUD

enum LoginStyle {
    case physic
    case urlica
}

class LoginVC: UIViewController {
    
    let bankImg = UIImageView()
    
    let loginField = CustomTextField()
    let phoneField = CustomTextField(field: SimplePhoneField())
    let passField = CustomTextField()
    let fieldsStack = UIStackView()
    
    let fullStack = UIStackView()
    
    let forgotPassBtn = UIButton(type: .system)
    let loginBtn = UIButton(type: .system)
    let regBtn = UIButton(type: .system)
    
    let titleLabel = UILabel()
    let entryLabel = UILabel()
    
    let urLicoBtn = RoundedBtn(type: .system)
    
    let loginStyle = BehaviorRelay<LoginStyle>(value: .physic)
    
    let disposeBag = DisposeBag()
    
    let provider: ApiProvider
    
    init(provider: ApiProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginField.field.becomeFirstResponder()
    }
    
    var yPosConstraint: NSLayoutConstraint?
    var keyboardHeight = CGFloat(0)
    
    func setupUI() {
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        view.backgroundColor = .white
        
        fieldsStack.alignment = .center
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .equalSpacing
        fieldsStack.spacing = 16
        
        fullStack.alignment = .center
        fullStack.axis = .vertical
        fullStack.distribution = .equalSpacing
        fullStack.spacing = 40
        
        fieldsStack.addArrangedSubview(titleLabel)
        fieldsStack.addArrangedSubview(entryLabel)
        fieldsStack.addArrangedSubview(loginField)
        fieldsStack.addArrangedSubview(phoneField)
        fieldsStack.addArrangedSubview(passField)
        fieldsStack.addArrangedSubview(forgotPassBtn)
        fieldsStack.addArrangedSubview(loginBtn)
        fieldsStack.addArrangedSubview(regBtn)
        
        phoneField.isHidden = true
        
        fullStack.addArrangedSubview(bankImg)
        fullStack.addArrangedSubview(fieldsStack)
        fullStack.addArrangedSubview(urLicoBtn)
        
        view.addSubview(fullStack)
        
        setEqualW(fieldsStack, views: titleLabel, entryLabel, forgotPassBtn, regBtn, loginField, passField, loginBtn, phoneField)
        
        constrain(fieldsStack, view, loginField, passField, loginBtn, fullStack, phoneField)
        { (fieldsStack, view, loginField, passField, loginBtn, fullStack, phoneField) in
            
            loginField.height == 52
            passField.height == 52
            loginBtn.height == 52
            phoneField.height == 52
            fieldsStack.width == fullStack.width
            
            fullStack.leading == view.leading + 20
            fullStack.trailing == view.trailing - 20
        }
        
        constrain(bankImg, fullStack, urLicoBtn) { (bankImg, fullStack, urLicoBtn) in
        bankImg.width == Images.bankLogo!.size.width
        bankImg.height == Images.bankLogo!.size.height
        urLicoBtn.width == fullStack.width
        urLicoBtn.height == 52
        }
        
        yPosConstraint = NSLayoutConstraint(item: fullStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        yPosConstraint?.isActive = true
        
        titleLabel.font = .h2(.bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .fieldActive
        titleLabel.text = "Инициативы"
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        
        entryLabel.font = .h3(.bold)
        entryLabel.textColor = .primaryText
        entryLabel.textAlignment = .center
        entryLabel.text = "Вход для физических лиц"
        entryLabel.minimumScaleFactor = 0.5
        entryLabel.adjustsFontSizeToFitWidth = true
        
        bankImg.image = Images.bankLogo
        
        loginField.field.placeholder = "Логин"
        loginField.layer.cornerRadius = 10
        loginField.field.font = .b2()
        loginField.backgroundColor = .white
        loginField.field.autocapitalizationType = .none
        loginField.field.returnKeyType = .next
        loginField.field.keyboardType = .emailAddress
        loginField.img.image = Images.mail
        
        phoneField.field.placeholder = "Телефон"
        phoneField.layer.cornerRadius = 10
        phoneField.field.font = .b2()
        phoneField.backgroundColor = .white
        phoneField.field.autocapitalizationType = .none
        phoneField.field.returnKeyType = .next
        phoneField.field.keyboardType = .phonePad
        phoneField.img.image = Images.phone
        
        passField.field.placeholder = "Пароль"
        passField.layer.cornerRadius = 10
        passField.field.font = .b2()
        passField.backgroundColor = .white
        passField.field.isSecureTextEntry = true
        passField.field.returnKeyType = .done
        passField.img.image = Images.password
        
        loginBtn.setTitle("Войти", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 52 / 2
        loginBtn.clipsToBounds = true
        loginBtn.titleLabel?.font = .b2(.bold)
        loginBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        urLicoBtn.setTitle("Вход для юридических лиц", for: .normal)
        urLicoBtn.setTitleColor(.primaryText, for: .normal)
        urLicoBtn.clipsToBounds = true
        urLicoBtn.titleLabel?.font = .b2(.bold)
        urLicoBtn.layer.borderWidth = 1
        urLicoBtn.layer.borderColor = UIColor.border.cgColor
        urLicoBtn.titleLabel?.minimumScaleFactor = 0.5
        urLicoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let forAttr = [NSAttributedString.Key.foregroundColor : UIColor.fieldActive]
        let forgotTitle = NSAttributedString(string: "Забыли пароль?",
                                             attributes: forAttr)
        forgotPassBtn.setAttributedTitle(forgotTitle, for: .normal)
        forgotPassBtn.titleLabel?.font = .b3()
        
        let regAttr = [NSAttributedString.Key.foregroundColor : UIColor.primaryText]
        let regTitle = NSMutableAttributedString(string: "Нет аккаунта?\n",
                                                 attributes: regAttr)
        regTitle.append(NSAttributedString(string: "Зарегистрироваться",
                                           attributes: forAttr))
        regBtn.setAttributedTitle(regTitle, for: .normal)
        regBtn.titleLabel?.font = .b3()
        regBtn.titleLabel?.numberOfLines = 2
        regBtn.titleLabel?.textAlignment = .center
        
        regBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            let vc = RegisterVC()
            self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func toggleEntryTitle() {
        if entryLabel.text == "Вход для юридических лиц" {
            entryLabel.text = "Вход для физических лиц"
            urLicoBtn.setTitle("Вход для юридических лиц", for: .normal)
            phoneField.isHidden = false
            loginField.isHidden = true
        } else {
            entryLabel.text = "Вход для юридических лиц"
            urLicoBtn.setTitle("Вход для физических лиц", for: .normal)
            phoneField.isHidden = true
            loginField.isHidden = false
        }
    }
    
    func toggleStyle() {
        loginStyle.accept(loginStyle.value == .physic ? .urlica : .physic)
    }
    
    func setupModel() {
        
//        RxKeyboard.instance.willShowVisibleHeight.distinctUntilChanged()
//            .drive(onNext: { [unowned self] height in
//                let underHalfHeight = self.fieldsStack.frame.height / 2
//                let halfHeight = self.view.frame.height / 2
//                let constant = halfHeight - height - underHalfHeight - 16
//                self.updateY(const: max(0, constant))
//            }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.reguestAuth()
        }).disposed(by: disposeBag)
        
        
        urLicoBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
            self.toggleStyle()
        }).disposed(by: disposeBag)
        
        loginStyle.subscribe(onNext: { [unowned self] _ in
            self.toggleEntryTitle()
        }).disposed(by: disposeBag)
        
        loginField.field.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { [unowned self] _ in
            self.passField.field.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        phoneField.field.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { [unowned self] _ in
            self.passField.field.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        passField.field.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { [unowned self] _ in
            self.reguestAuth()
        }).disposed(by: disposeBag)
    }
    
    func updateY(const: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.yPosConstraint?.constant = const
            self.view.layoutIfNeeded()
        }
    }
    
    func successAuth() {
        let vc = MainTabBar.getTabBar()
//        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func reguestAuth() {
        view.endEditing(true)
        HUD.show(.progress)
        let loginText = loginStyle.value == .urlica ? phoneField.field.text : loginField.field.text
        let passText = passField.field.text
        if loginText.isNilOrEmpty {
            if loginStyle.value == .urlica {
                HUD.flash(.label("Проверьте поле телефона"), onView: nil, delay: 0.5) { [unowned self] (_) in
                    self.phoneField.field.becomeFirstResponder()
                }
            } else {
                HUD.flash(.label("Проверьте поле логина"), onView: nil, delay: 0.5) { [unowned self] (_) in
                    self.loginField.field.becomeFirstResponder()
                }
            }
            return
        }
        if passText.isNilOrEmpty {
            HUD.flash(.label("Проверьте поле пароля"), onView: nil, delay: 0.5) { [unowned self] (_) in
                self.passField.field.becomeFirstResponder()
            }
            return
        }
        let request = LoginRequest(login: loginText, pass: passText)
        provider.auth(request: request).subscribe(onNext: { [unowned self] result in
            self.handleAuth(result: result)
            }).disposed(by: disposeBag)
    }
    
    func handleAuth(result: ApiProvider.AuthResult) {
        HUD.hide()
        switch result {
        case let .success(response):
            UserDefaults.standard.authToken = response.token
            profileKind = response.kind
            successAuth()
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
    }
    
}
