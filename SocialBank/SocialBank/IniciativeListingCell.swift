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
    let date = UILabel()
    let title = UILabel()
    let descriptionLabel = UILabel()
    let votesView = VotesStackView()
    let stack = UIStackView()
    let dateLabel = UILabel()
    
    let circle = RatingCircleView()
    
    let voteChanged = PublishSubject<VoteChanged>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .white
        applyShadow(height: 20, radius: 30)
        contentView.addSubview(stack)
        let firstView = UIStackView()
        let lastView = UIView()
        let titleStack = UIStackView()
        lastView.addSubview(dateLabel)
        lastView.addSubview(votesView)
        firstView.addArrangedSubview(circle)
        firstView.addArrangedSubview(titleStack)
        firstView.addArrangedSubview(chevron)
        titleStack.addArrangedSubview(date)
        titleStack.addArrangedSubview(title)
        
        setEqualW(titleStack, views: date, title)
        
        stack.addArrangedSubview(firstView)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(lastView)
        
        chevron.image = Images.chevron
        chevron.contentMode = .scaleAspectFit
        
        constrain(chevron) { (chevron) in
            chevron.height == 13
            chevron.width == 13
        }
        
        constrain(contentView, stack, firstView, circle, title, descriptionLabel, votesView, lastView, dateLabel)
        { (contentView, stack, firstView, circle, title, descriptionLabel, votesView, lastView, dateLabel) in
            stack.edges == inset(contentView.edges, 16, 16, 16, 16)
            
            firstView.width == stack.width
            descriptionLabel.width == stack.width
            lastView.width == stack.width
            
            circle.width == 60
            circle.height == 80
            
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
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5
        
        title.numberOfLines = 2
        title.font = .b1(.semibold)
        title.textColor = .primaryText
        
        date.font = .b3()
        date.textColor = .primaryText
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        firstView.alignment = .center
        firstView.axis = .horizontal
        firstView.distribution = .fillProportionally
        firstView.spacing = 16
        
        titleStack.alignment = .center
        titleStack.axis = .vertical
        titleStack.distribution = .equalSpacing
        titleStack.spacing = 8
        
        contentView.layer.cornerRadius = 30
        layer.cornerRadius = 30
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
        circle.circle.value = CGFloat(item.rating)
        date.text = "Дата: " + item.justDateText
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
        h += 35 + 80
//        let result =  + CGFloat(40 + 48 + 52 + 16)
//        print(result)
//        return result
        return h
    }
    
}
