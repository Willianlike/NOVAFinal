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

class LoginVC: UIViewController {
    
    let bankImg = UIImageView()
    
    let loginField = CustomTextField()
    let passField = CustomTextField()
    let fieldsStack = UIStackView()
    
    let fullStack = UIStackView()
    
    let forgotPassBtn = UIButton(type: .system)
    let loginBtn = UIButton(type: .system)
    let regBtn = UIButton(type: .system)
    
    let titleLabel = UILabel()
    let entryLabel = UILabel()
    
    let urLicoBtn = RoundedBtn(type: .system)
    
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
        loginField.becomeFirstResponder()
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
        fieldsStack.spacing = 10
        
        fullStack.alignment = .center
        fullStack.axis = .vertical
        fullStack.distribution = .equalSpacing
        fullStack.spacing = 40
        
        fieldsStack.addArrangedSubview(titleLabel)
        fieldsStack.addArrangedSubview(entryLabel)
        fieldsStack.addArrangedSubview(loginField)
        fieldsStack.addArrangedSubview(passField)
        fieldsStack.addArrangedSubview(forgotPassBtn)
        fieldsStack.addArrangedSubview(loginBtn)
        fieldsStack.addArrangedSubview(regBtn)
        
        fullStack.addArrangedSubview(bankImg)
        fullStack.addArrangedSubview(fieldsStack)
        fullStack.addArrangedSubview(urLicoBtn)
        
        view.addSubview(fullStack)
        
        constrain(fieldsStack, view, titleLabel, entryLabel, forgotPassBtn, regBtn, loginField, passField, loginBtn, fullStack)
        { (fieldsStack, view, titleLabel, entryLabel, forgotPassBtn, regBtn, loginField, passField, loginBtn, fullStack) in
            loginField.width == fieldsStack.width
            passField.width == fieldsStack.width
            loginBtn.width == fieldsStack.width
            entryLabel.width == fieldsStack.width
            titleLabel.width == fieldsStack.width
            forgotPassBtn.width == fieldsStack.width
            regBtn.width == fieldsStack.width
            
            loginField.height == 52
            passField.height == 52
            loginBtn.height == 52
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
        
        titleLabel.font = .h1(.bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .fieldActive
        titleLabel.text = "Инициативы"
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        
        entryLabel.font = .h2(.bold)
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
        loginBtn.titleLabel?.font = .b1(.bold)
        loginBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        loginBtn.setTitle("Войти", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 52 / 2
        loginBtn.clipsToBounds = true
        loginBtn.titleLabel?.font = .b1(.bold)
        loginBtn.setBackgroundImage(Images.barBack, for: .normal)
        
        urLicoBtn.setTitle("Вход для юридических лиц", for: .normal)
        urLicoBtn.setTitleColor(.primaryText, for: .normal)
        urLicoBtn.clipsToBounds = true
        urLicoBtn.titleLabel?.font = .b1(.bold)
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
    }
    
    func toggleEntryTitle() {
        if entryLabel.text == "Вход для юридических лиц" {
            entryLabel.text = "Вход для физических лиц"
            urLicoBtn.setTitle("Вход для юридических лиц", for: .normal)
        } else {
            entryLabel.text = "Вход для юридических лиц"
            urLicoBtn.setTitle("Вход для физических лиц", for: .normal)
        }
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
            self.toggleEntryTitle()
        }).disposed(by: disposeBag)
        
        loginField.field.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { [unowned self] _ in
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reguestAuth() {
        view.endEditing(true)
        HUD.show(.progress)
        let loginText = loginField.field.text
        let passText = passField.field.text
        if loginText.isNilOrEmpty {
            HUD.flash(.label("Проверьте поле логина"), onView: nil, delay: 0.5) { [unowned self] (_) in
                self.loginField.field.becomeFirstResponder()
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
            successAuth()
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
    }
    
}
