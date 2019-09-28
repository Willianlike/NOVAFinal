//
//  SectionView.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class SectionView: UIView {
    
    init(title: String, view: UIView) {
        super.init(frame: CGRect())
        
        let header = UILabel()
        header.font = .b1()
        header.numberOfLines = 0
        header.textColor = .primaryText
        header.text = title
        
        addSubview(header)
        addSubview(view)
        
        constrain(view, header, self) { (view, header, superV) in
            header.leading == superV.leading
            header.top == superV.top + 16
            header.trailing == superV.trailing
            
            view.leading == superV.leading
            view.top == header.bottom + 16
            view.trailing == superV.trailing
            view.bottom == superV.bottom - 16
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
