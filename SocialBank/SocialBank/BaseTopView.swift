//
//  BaseTopView.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class BaseTopView: UIView {
    
    let backBtn = UIButton(type: .system)
    let title = UILabel()
    
    init() {
        super.init(frame: CGRect())
        
        addSubview(backBtn)
        addSubview(title)
        
        backBtn.setImage(Images.back, for: .normal)
        backBtn.tintColor = .white
        
        title.textColor = .white
        title.numberOfLines = 0
        title.textAlignment = .center
        
        let backSize = CGSize(width: 52, height: 52)
        
        constrain(self, title, backBtn) { (view, title, backBtn) in
        backBtn.height == backSize.height
        backBtn.width == backSize.width
            backBtn.centerY == view.centerY
            backBtn.leading == view.leading + 16
            backBtn.top >= view.top + 8
            backBtn.bottom <= view.bottom - 8
            
            title.leading == backBtn.trailing + 8
            title.top == view.top + 8
            title.bottom == view.bottom - 16
            title.trailing == view.trailing - 16 - backSize.width - 8
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
