//
//  KnowledgeCollectionCell.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class KnowledgeCollectionCell: UICollectionViewCell, ReusableView {
    
    let title = UILabel()
    let comment = UILabel()
    let img = UIImageView()
    let chevron = UIImageView()
    
    let stack = UIStackView()
    let topStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: KnowledgeModel) {
        title.text = item.title
        comment.text = item.comment
        img.setUrlImage(url: item.image, placeholder: Images.profile_hint)
    }
    
    static func getHeight(w: CGFloat, item: KnowledgeModel) -> CGFloat {
        var h = CGFloat(40)
        let ww = w - 32
        let ww2 = ww - 39 - 8 - 20
        
        print(ww, ww2)
        h += max(36, item.title.height(withConstrainedWidth: ww2, font: .b2(.bold)))
        h += item.comment.height(withConstrainedWidth: ww, font: .b3())
        return h
    }
    
    func setupUI() {
        backgroundColor = .white
        applyShadow(height: 15, radius: 30)
        topStack.addArrangedSubview(img)
        topStack.addArrangedSubview(title)
        topStack.addArrangedSubview(chevron)
        stack.addArrangedSubview(topStack)
        stack.addArrangedSubview(comment)
        contentView.addSubview(stack)
        
        chevron.image = Images.chevron
        chevron.contentMode = .scaleAspectFit
        
        setEqualW(stack, views: comment, topStack)

        let imgSize = CGSize(width: 36, height: 36)
        
        constrain(stack, contentView, self, img) { (stack, contentView, view, img) in
            stack.edges == inset(contentView.edges, 16)
//            img.centerY == view.top + imgSize.height / 4
            img.height == imgSize.height
            img.width == imgSize.width
//            img.trailing == view.trailing - 16
        }
        
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        topStack.alignment = .center
        topStack.axis = .horizontal
        topStack.distribution = .fillProportionally
        topStack.spacing = 10
        
        title.textColor = .primaryText
        title.font = .b2(.bold)
        title.numberOfLines = 0
        
        comment.textColor = .primaryText
        comment.font = .b3()
        comment.numberOfLines = 0
        
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = imgSize.height / 2
        img.clipsToBounds = true
        
        contentView.layer.cornerRadius = 30
        layer.cornerRadius = 30
    }
    
}
