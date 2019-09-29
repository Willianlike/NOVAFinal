//
//  CustomTextField.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class CustomTextField: UIView {
    
    let field: UITextField
    let img = UIImageView()
    let border = UIView()
    
    init(field: UITextField = UITextField()) {
        self.field = field
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    func setupUI() {
        addSubview(field)
        addSubview(img)
        addSubview(border)
        constrain(self, field, img, border) { (view, field, img, border) in
            img.width == img.height
            img.leading == view.leading
            img.top == view.top
            img.bottom == view.bottom
            
            field.leading == img.trailing
            field.trailing == view.trailing
            field.top == view.top
            field.bottom == view.bottom
            
            border.leading == view.leading
            border.trailing == view.trailing
            border.bottom == view.bottom
            border.height == 2
        }
        self.border.backgroundColor = .border
        self.img.tintColor = .border
        img.contentMode = .center
        field.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [unowned self] _ in
                self.border.backgroundColor = .fieldActive
                self.img.tintColor = .fieldActive
            }).disposed(by: disposeBag)
        field.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                self.border.backgroundColor = .border
                self.img.tintColor = .border
            }).disposed(by: disposeBag)
    }
    
}
