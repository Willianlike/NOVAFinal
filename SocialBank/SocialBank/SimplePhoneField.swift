//
//  SimplePhoneField.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import InputMask

class SimplePhoneField: UITextField {

    open var maskDelegate = MaskedTextFieldDelegate(primaryFormat: "+7[0000000000]")
    
    init() {
        super.init(frame: CGRect())
        delegate = maskDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
