//
//  PhoneField.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import InputMask

class PhoneField: SimplePhoneField {

    override init() {
        super.init()
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
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
