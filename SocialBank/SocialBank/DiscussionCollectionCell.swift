//
//  DiscussionCollectionCell.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class DiscussionCollectionCell: UICollectionViewCell, ReusableView {
    
    let img = UIImageView()
    let name = UILabel()
    let online = UILabel()
    let date = UILabel()
    let comment = UILabel()
    
    let stack = UIStackView()
    let horizontalStack = UIView()
    let nameStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: DiscussionModel) {
        print(item)
        name.text = item.name
        online.text = item.isOnline ? "Онлайн" : "Не онлайн"
        comment.text = item.comment
        img.setUrlImage(url: item.img, placeholder: Images.profile_hint)
        date.text = item.dateText
    }
    
    static func getHeight(w: CGFloat, item: DiscussionModel) -> CGFloat {
        var h = CGFloat(48)
        h += 40
        h += item.comment.height(withConstrainedWidth: w - 32, font: .b3())
        return h
    }
    
    func setupUI() {
        contentView.addSubview(stack)
        stack.addArrangedSubview(horizontalStack)
        stack.addArrangedSubview(comment)
        
        nameStack.addArrangedSubview(name)
        nameStack.addArrangedSubview(online)
        
        horizontalStack.addSubview(img)
        horizontalStack.addSubview(nameStack)
        horizontalStack.addSubview(date)
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        nameStack.alignment = .center
        nameStack.axis = .vertical
        nameStack.distribution = .equalSpacing
        nameStack.spacing = 8
        
//        horizontalStack.alignment = .fill
//        horizontalStack.axis = .horizontal
//        horizontalStack.distribution = .fill
//        horizontalStack.spacing = 8

let imgSize = CGSize(width: 48, height: 48)
        
        constrain(horizontalStack, img, nameStack, date)
        { (view, img, nameStack, date) in
        img.height == imgSize.height
        img.width == imgSize.width
            img.top >= view.top
            img.bottom <= view.bottom
            img.centerY == view.centerY
            img.leading == view.leading
            
            date.trailing == view.trailing
            date.top == view.top
            date.bottom == view.bottom
            date.width == "00:00".width(withConstrainedHeight: 100, font: .b3())
            
            nameStack.top == view.top
            nameStack.bottom == view.bottom
            nameStack.leading == img.trailing + 16
            nameStack.trailing == date.leading
        }
        
        comment.textColor = .primaryText
        comment.font = .b3()
        comment.numberOfLines = 0
        
        date.textColor = .border
        date.font = .b3()
        
        name.textColor = .primaryText
        name.font = .b2(.bold)
        name.numberOfLines = 2
        
        online.textColor = UIColor.primaryText.withAlphaComponent(0.7)
        online.font = .b3()
        online.text = "Online"
        
        img.layer.cornerRadius = imgSize.height / 2
        img.clipsToBounds = true
        
        setEqualW(nameStack, views: name, online)
        setEqualW(stack, views: comment, horizontalStack)
        
        constrain(stack, contentView) { (stack, view) in
            stack.edges == inset(view.edges, 16)
        }
        
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = imgSize.height / 2
    }
    
}
