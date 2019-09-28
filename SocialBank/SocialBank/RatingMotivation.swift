//
//  RatingMotivation.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class RatingMotivation: UIView {
    
    let title = UILabel()
    let desc = UILabel()
    let button = VoteButton(type: .system)
    
    let stack = UIStackView()
    
    init() {
        super.init(frame: CGRect())
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(desc)
        stack.addArrangedSubview(button)
        
        title.text = "Оцените данную инициативу"
        desc.text = "для получения очков"
        
        title.textColor = .primaryText
        title.font = .h4(.semibold)
        title.numberOfLines = 0
        title.textAlignment = .center
        
        desc.textColor = .primaryText
        desc.font = .b2()
        desc.numberOfLines = 0
        desc.textAlignment = .center
        
        addSubview(stack)
        
        constrain(stack, self, title, desc, button) { (stack, view, title, desc, button) in
            stack.edges == inset(view.edges, 52, 8, 52, 8)
//            title.width == stack.width
//            desc.width == stack.width
            
            button.height == 36
            button.width == 75
        }
        
//        button.setImage(Images.lock, for: .normal)
        button.setTitle("+5", for: .normal)
        button.setTitleColor(.primaryText, for: .disabled)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primaryText.cgColor
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.isEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
