//
//  InactiveListtopBar.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class InactiveListtopBar: UIView {
    
    let controlBar = CustomSegmentedContrl()
    let titleLabel = UILabel()
    let searchBtn = UIButton(type: .system)
    
    let top = UIView()
    let bot = UIView()
    let topDump = UIView()
    let stack = UIStackView()
    let backimg = UIImageView()
    
    static let topH = CGFloat(44)
    static let botH = CGFloat(44)
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        
        controlBar.selectorColor = .segmentActive
        controlBar.selectorTextColor = .segmentActive
        controlBar.textColor = .segmentInactive
        controlBar.backgroundColor = .clear
        
        titleLabel.font = .h2(.bold)
        titleLabel.textColor = .topBarText
        titleLabel.text = "Инициативы"
        
        searchBtn.setImage(Images.search, for: .normal)
        searchBtn.tintColor = .topBarText
        
        top.addSubview(titleLabel)
        top.addSubview(searchBtn)
        
        bot.addSubview(controlBar)
        
        backimg.image = Images.barBack
        backimg.contentMode = .scaleAspectFill
        
        stack.addArrangedSubview(topDump)
        stack.addArrangedSubview(top)
        stack.addArrangedSubview(bot)
        
        self.addSubview(backimg)
        self.addSubview(stack)
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 0
        
        constrain(self, topDump, backimg, stack, top, bot, titleLabel, searchBtn, controlBar)
        { (view, topDump, backimg, stack, top, bot, titleLabel, searchBtn, controlBar) in
            searchBtn.trailing == top.trailing
            searchBtn.top >= top.top
            searchBtn.bottom <= top.bottom
            searchBtn.centerY == top.centerY
            searchBtn.width == InactiveListtopBar.topH
            searchBtn.height == InactiveListtopBar.topH
            
            titleLabel.leading == top.leading
            titleLabel.trailing == searchBtn.leading - 8
            titleLabel.top == top.top
            titleLabel.bottom == top.bottom
            
            controlBar.edges == bot.edges
            
            top.width == stack.width
            bot.width == stack.width
            
            top.height == InactiveListtopBar.topH
            bot.height == InactiveListtopBar.botH
            topDump.height == UIApplication.shared.statusBarFrame.height
            
            backimg.edges == view.edges
            
            stack.edges == inset(view.edges, 0, 16, 0, 16)
        }
        
    }
    
}
