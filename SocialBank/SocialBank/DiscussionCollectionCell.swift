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
    let replyImg = UIImageView()
    let name = UILabel()
    let online = UILabel()
    let date = UILabel()
    let comment = UILabel()
    let replyToLabel = UILabel()
    
    let stack = UIStackView()
    let horizontalStack = UIView()
    let nameStack = UIStackView()
    let commentStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: DiscussionModel, allItems: [DiscussionModel]) {
        name.text = item.name
        online.text = item.isOnline ? "Онлайн" : "Не онлайн"
        comment.text = item.comment
        img.setUrlImage(url: item.img, placeholder: Images.profile_hint)
        date.text = item.dateText
        replyImg.isHidden = !item.replyed
        updateColors(replyed: item.replyed)
        if let repl = item.replyTo, let itemRepl = allItems.first(where: { $0.id == repl }) {
            let text = DiscussionCollectionCell.getNSAttr(item: itemRepl)
            replyToLabel.attributedText = text
            replyToLabel.isHidden = false
        } else {
            replyToLabel.isHidden = true
        }
    }
    
    static func getNSAttr(item: DiscussionModel) -> NSAttributedString {
        let text = NSMutableAttributedString(string: "В ответ на сообщение: \(item.name)", attributes: [NSAttributedString.Key.font : UIFont.b3(.semibold), NSAttributedString.Key.foregroundColor : UIColor.primaryText])
        text.append(NSAttributedString(string: "\n\"\(item.comment)\"\n", attributes: [NSAttributedString.Key.font : UIFont.b3(), NSAttributedString.Key.foregroundColor : UIColor.primaryText]))
        return text
    }
    
    func updateColors(replyed: Bool) {
        if replyed {
            backgroundColor = .reply
            name.textColor = .white
            comment.textColor = .white
        } else {
            backgroundColor = .white
            name.textColor = .primaryText
            comment.textColor = .primaryText
        }
        applyShadow(height: 15, radius: 30)
    }
    
    static func getHeight(w: CGFloat, item: DiscussionModel, allItems: [DiscussionModel]) -> CGFloat {
        var h = CGFloat(48)
        h += 40
        let ww = w - 32 - (item.replyed ? 24 : 0)
        h += item.comment.height(withConstrainedWidth: ww, font: .b3())
        if let repl = item.replyTo, let itemRepl = allItems.first(where: { $0.id == repl }) {
            let text = getNSAttr(item: itemRepl)
            h += text.height(containerWidth: w - 32) + 8
        }
        return h
    }
    
    func setupUI() {
        backgroundColor = .white
        applyShadow(height: 15, radius: 30)
        
        contentView.addSubview(stack)
        stack.addArrangedSubview(replyToLabel)
        stack.addArrangedSubview(horizontalStack)
        stack.addArrangedSubview(commentStack)
        
        replyToLabel.isHidden = true
        
        commentStack.addArrangedSubview(replyImg)
        commentStack.addArrangedSubview(comment)
        
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
        
        commentStack.alignment = .center
        commentStack.axis = .horizontal
        commentStack.distribution = .fillProportionally
        commentStack.spacing = 8

        let imgSize = CGSize(width: 48, height: 48)
        
        constrain(horizontalStack, img, nameStack, date, replyImg)
        { (view, img, nameStack, date, replyImg) in
            
            replyImg.width == 16
            replyImg.height == 16
            
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
        
        replyImg.tintColor = .white
        replyImg.image = Images.reply
        
        date.textColor = UIColor.primaryText.withAlphaComponent(0.7)
        date.font = .b3()
        
        name.textColor = .primaryText
        name.font = .b2(.bold)
        name.numberOfLines = 2
        
        online.textColor = UIColor.primaryText.withAlphaComponent(0.7)
        online.font = .b3()
        online.text = "Online"
        
        img.layer.cornerRadius = imgSize.height / 2
        img.clipsToBounds = true
        
        replyToLabel.numberOfLines = 0
        
        setEqualW(nameStack, views: name, online)
        setEqualW(stack, views: commentStack, horizontalStack, replyToLabel)
        
        constrain(stack, contentView) { (stack, view) in
            stack.edges == inset(view.edges, 16)
        }
        
        contentView.layer.cornerRadius = 30
        layer.cornerRadius = 30
    }
    
}
