//
//  SelectorCell.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography

class SelectorCell: UITableViewCell, ReusableView {
    
    let checkImg = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(checkImg)
        contentView.addSubview(titleLabel)
        
        checkImg.image = Images.radio_empty
        checkImg.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .b2()
        titleLabel.textColor = .primaryText
        
        constrain(checkImg, titleLabel, contentView)
        { (checkImg, titleLabel, contentView) in
            checkImg.width == Images.radio_empty!.size.width
            checkImg.height == checkImg.width
            checkImg.centerY == contentView.centerY
            checkImg.leading == contentView.leading
            checkImg.top >= contentView.top + 8
            checkImg.bottom <= contentView.bottom - 8
            
            titleLabel.leading == checkImg.trailing + 16
            titleLabel.top == contentView.top + 8
            titleLabel.bottom == contentView.bottom - 8
            titleLabel.trailing == contentView.trailing - 16
            
        }
    }
    
    func setup(item: SelectorItemModel) {
        checkImg.image = item.selected ? Images.radio_selected : Images.radio_empty
        titleLabel.text = item.title
    }
    
}
