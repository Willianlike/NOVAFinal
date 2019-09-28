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
    let chevron = UIImageView()
    let title = UILabel()
    let descriptionLabel = UILabel()
    let votesView = VotesStackView()
    let stack = UIStackView()
    let dateLabel = UILabel()
    
    let voteChanged = PublishSubject<VoteChanged>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(stack)
        let firstView = UIStackView()
        let lastView = UIView()
        lastView.addSubview(dateLabel)
        lastView.addSubview(votesView)
        firstView.addArrangedSubview(icon)
        firstView.addArrangedSubview(title)
        firstView.addArrangedSubview(chevron)
        
        stack.addArrangedSubview(firstView)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(lastView)
        
        chevron.image = Images.chevron
        chevron.contentMode = .scaleAspectFit
        
        constrain(chevron) { (chevron) in
            chevron.height == 13
            chevron.width == 13
        }
        
        constrain(contentView, stack, firstView, icon, title, descriptionLabel, votesView, lastView, dateLabel)
        { (contentView, stack, firstView, icon, title, descriptionLabel, votesView, lastView, dateLabel) in
            stack.edges == inset(contentView.edges, 16, 16, 16, 16)
            
            firstView.width == stack.width
            descriptionLabel.width == stack.width
            lastView.width == stack.width
            
            icon.width == 40
            icon.height == 40
//            icon.leading == firstView.leading
//            icon.top >= firstView.top
//            icon.bottom <= firstView.bottom
//            icon.centerY == firstView.centerY
//            
//            title.leading == icon.trailing + 16
//            title.top == firstView.top
//            title.bottom == firstView.bottom
//            title.trailing == firstView.trailing
            
            votesView.top == lastView.top
            votesView.bottom == lastView.bottom
            votesView.trailing == lastView.trailing
            votesView.leading >= lastView.leading
            
            dateLabel.top == lastView.top
            dateLabel.bottom == lastView.bottom
            dateLabel.trailing <= votesView.leading
            dateLabel.leading == lastView.leading
        }
        
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = .b3()
        descriptionLabel.textColor = .primaryText
        
        dateLabel.font = .b3()
        dateLabel.textColor = .primaryText
        
        title.numberOfLines = 2
        title.font = .b1(.semibold)
        title.textColor = .primaryText
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        firstView.alignment = .center
        firstView.axis = .horizontal
        firstView.distribution = .fillProportionally
        firstView.spacing = 16
        
        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.border.cgColor
    }
    
    var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(item: BankIniciativeModel, provider: ApiProvider) {
        icon.setUrlImage(url: item.image)
        icon.isHidden = item.image == nil
        title.text = item.title
        descriptionLabel.text = item.description
        votesView.upvoteCount = item.upvotes
        votesView.downvoteCount = item.downvotes
        votesView.voteStatus = item.voteStatus
        votesView.voteStatusChanged.asObservable().map { (item.id, $0) }
            .bind(to: voteChanged).disposed(by: disposeBag)
        dateLabel.text = item.dateText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    static func getCellHeight(width: CGFloat, item: BankIniciativeModel) -> CGFloat {
        var h = CGFloat(48)
        let descMaxH = "1\n2\n3\n4\n5".height(withConstrainedWidth: width, font: .b3())
        let descH = item.description.height(withConstrainedWidth: width, font: .b3())
        h += CGFloat(min(descH,descMaxH))
        h += 35 + 40
//        let result =  + CGFloat(40 + 48 + 52 + 16)
//        print(result)
//        return result
        return h
    }
    
}
