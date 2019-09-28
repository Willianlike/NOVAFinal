//
//  EnterCodeVC.swift
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

class EnterCodeVC: UIViewController {
    
    let codeField = UITextField()
    let fieldsStack = UIStackView()
    
    let enterBtn = UIButton(type: .system)
    
    let disposeBag = DisposeBag()
    
    init() {
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeField.becomeFirstResponder()
    }
    
    var yPosConstraint: NSLayoutConstraint?
    var keyboardHeight = CGFloat(0)
    
    func setupUI() {
//        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
//            self.view.endEditing(true)
//            }).disposed(by: disposeBag)
        
        view.backgroundColor = .blue
        
        fieldsStack.alignment = .center
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .equalSpacing
        fieldsStack.spacing = 16
        
        fieldsStack.addArrangedSubview(codeField)
        fieldsStack.addArrangedSubview(enterBtn)
        
        view.addSubview(fieldsStack)
        
        constrain(fieldsStack, view, codeField, enterBtn)
        { (fieldsStack, view, codeField, enterBtn) in
            codeField.width == fieldsStack.width
            enterBtn.width == fieldsStack.width
            
            codeField.height == 52
            enterBtn.height == 52
            
            fieldsStack.leading == view.leading + 16
            fieldsStack.trailing == view.trailing - 16
        }
        
        yPosConstraint = NSLayoutConstraint(item: fieldsStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        yPosConstraint?.isActive = true
        
        codeField.placeholder = "Введите код"
        codeField.textAlignment = .center
        codeField.layer.cornerRadius = 10
        codeField.font = UIFont.systemFont(ofSize: 17)
        codeField.backgroundColor = .white
        codeField.keyboardType = .decimalPad
        
        enterBtn.setTitle("Отправить", for: .normal)
        enterBtn.setTitleColor(.white, for: .normal)
        enterBtn.layer.cornerRadius = 10
        enterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        enterBtn.backgroundColor = .orange
    }
    
    func setupModel() {
        
        RxKeyboard.instance.visibleHeight.distinctUntilChanged()
        .filter({ $0 != 0})
            .drive(onNext: { [unowned self] height in
            let underHalfHeight = self.fieldsStack.frame.height / 2
            let halfHeight = self.view.frame.height / 2
            let constant = halfHeight - height - underHalfHeight - 16
            self.updateY(const: max(0, constant))
        }).disposed(by: disposeBag)
    }
    
    func updateY(const: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.yPosConstraint?.constant = const
            self.view.layoutIfNeeded()
        }
    }
    
}
