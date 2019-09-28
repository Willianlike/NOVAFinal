//
//  IniciativeListingCell.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class IniciativeListingCell: UICollectionViewCell, ReusableView {
    
    let icon = UIImageView()
    let title = UILabel()
    let descriptionLabel = UILabel()
    let votesView = VotesStackView()
    let stack = UIStackView()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(stack)
        let firstView = UIView()
        let lastView = UIView()
        lastView.addSubview(votesView)
        firstView.addSubview(icon)
        firstView.addSubview(title)
        
        stack.addArrangedSubview(firstView)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(lastView)
        
        constrain(contentView, stack, firstView, icon, title, descriptionLabel, votesView, lastView)
        { (contentView, stack, firstView, icon, title, descriptionLabel, votesView, lastView) in
            stack.edges == inset(contentView.edges, 16, 16, 16, 16)
            
            firstView.width == stack.width
            descriptionLabel.width == stack.width
            lastView.width == stack.width
            
            icon.width == 40
            icon.height == 40
            icon.leading == firstView.leading
            icon.top >= firstView.top
            icon.bottom <= firstView.bottom
            icon.centerY == firstView.centerY
            
            title.leading == icon.trailing + 16
            title.top == firstView.top
            title.bottom == firstView.bottom
            title.trailing == firstView.trailing
            
            votesView.top == lastView.top
            votesView.bottom == lastView.bottom
            votesView.trailing == lastView.trailing
            votesView.leading >= lastView.leading
        }
        
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = .b3()
        descriptionLabel.textColor = .primaryText
        
        title.numberOfLines = 2
        title.font = .b1(.semibold)
        title.textColor = .primaryText
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.border.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(item: BankIniciativeModel) {
        icon.setUrlImage(url: item.image)
        title.text = item.title
        descriptionLabel.text = item.description
        votesView.upvoteCount = item.upvotes
        votesView.downvoteCount = item.downvotes
        votesView.voteStatus = item.voteStatus
    }
    
    static func getCellHeight(width: CGFloat, item: BankIniciativeModel) -> CGFloat {
        let descMaxH = "1\n2\n3\n4\n5".height(withConstrainedWidth: width, font: .b3())
        let descH = item.description.height(withConstrainedWidth: width, font: .b3())
        let result = CGFloat(min(descH,descMaxH)) + CGFloat(40 + 48 + 52 + 32)
        print(result)
        return result
    }
    
}
