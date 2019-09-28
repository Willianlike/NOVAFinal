//
//  VotesStackView.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

typealias VoteChanged = (String, VoteStatus)

enum VoteStatus: String {
    case none
    case upvoted
    case downvoted
}

class VotesStackView: UIView {
    
    let stack = UIStackView()
    let upvoteBtn = VoteButton(type: .roundedRect)
    let downvoteBtn = VoteButton(type: .roundedRect)
    var upvoteWidth: NSLayoutConstraint?
    var downvoteWidth: NSLayoutConstraint?
    
    let voteStatusChanged = PublishSubject<VoteStatus>()
    
    let disposeBag = DisposeBag()
    
    var upvoteCount: Int = 0 {
        didSet {
            updateStatuses()
        }
    }
    
    var downvoteCount: Int = 0 {
        didSet {
            updateStatuses()
        }
    }
    
    var voteStatus: VoteStatus = .none {
        didSet {
            updateStatuses()
            updateVoteStatus()
            voteStatusChanged.onNext(voteStatus)
        }
    }
    
    private func updateStatuses() {
        setUpvotesCount(count: upvoteCount + (voteStatus == .upvoted ? 1 : 0))
        setDownvotesCount(count: downvoteCount + (voteStatus == .downvoted ? 1 : 0))
    }
    
    init() {
        super.init(frame: CGRect())
        setupUI()
        setupModel()
    }
    
    private func setupModel() {
        upvoteBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.voteStatus = self.voteStatus != .upvoted ? .upvoted : .none
        }).disposed(by: disposeBag)
        
        downvoteBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.voteStatus = self.voteStatus != .downvoted ? .downvoted : .none
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        addSubview(stack)
        
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 16
        
        stack.addArrangedSubview(downvoteBtn)
        stack.addArrangedSubview(upvoteBtn)
        
        let btnSize = CGSize(width: 35, height: 35)
        
        upvoteBtn.setImage(Images.upvote, for: .normal)
        upvoteBtn.layer.cornerRadius = btnSize.width/2
        upvoteBtn.clipsToBounds = true
        upvoteBtn.titleLabel?.font = .b3()
        upvoteBtn.imageView?.contentMode = .scaleAspectFit
        
        downvoteBtn.setImage(Images.downvote, for: .normal)
        downvoteBtn.layer.cornerRadius = btnSize.width/2
        downvoteBtn.clipsToBounds = true
        downvoteBtn.titleLabel?.font = .b3()
        downvoteBtn.imageView?.contentMode = .scaleAspectFit
        
        updateVoteStatus()
        
        constrain(self, stack, upvoteBtn, downvoteBtn)
        { (view, stack, upvoteBtn, downvoteBtn) in
            upvoteBtn.height == btnSize.height
            downvoteBtn.height == btnSize.height
            
            stack.edges == view.edges
        }
        
        upvoteWidth = NSLayoutConstraint(item: upvoteBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        upvoteWidth?.isActive = true
        
        downvoteWidth = NSLayoutConstraint(item: downvoteBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        downvoteWidth?.isActive = true
    }
    
    private func updateVoteStatus() {
        switch voteStatus {
        case .downvoted:
            setDownvoted()
        case .upvoted:
            setUpvoted()
        case .none:
            setVoteNone()
        }
        self.layoutIfNeeded()
    }
    
    private func setDownvoted() {
        downvoteBtn.tintColor = .voteText
        downvoteBtn.backgroundColor = .downvote
        downvoteBtn.layer.borderWidth = 0
        
        upvoteBtn.tintColor = .upvote
        upvoteBtn.backgroundColor = .clear
        upvoteBtn.layer.borderWidth = 1
        upvoteBtn.layer.borderColor = UIColor.upvote.cgColor
    }
    
    private func setUpvoted() {
        upvoteBtn.tintColor = .voteText
        upvoteBtn.backgroundColor = .upvote
        upvoteBtn.layer.borderWidth = 0
        
        downvoteBtn.tintColor = .downvote
        downvoteBtn.backgroundColor = .clear
        downvoteBtn.layer.borderWidth = 1
        downvoteBtn.layer.borderColor = UIColor.downvote.cgColor
    }
    
    private func setVoteNone() {
        upvoteBtn.tintColor = .upvote
        upvoteBtn.backgroundColor = .clear
        upvoteBtn.layer.borderWidth = 1
        upvoteBtn.layer.borderColor = UIColor.upvote.cgColor
        
        downvoteBtn.tintColor = .downvote
        downvoteBtn.backgroundColor = .clear
        downvoteBtn.layer.borderWidth = 1
        downvoteBtn.layer.borderColor = UIColor.downvote.cgColor
    }
    
    private func setUpvotesCount(count: Int) {
        let text = "\(count) "
        let w = text.width(withConstrainedHeight: 100, font: .b3())
        upvoteBtn.setTitle(text, for: .normal)
        self.layoutIfNeeded()
        upvoteWidth?.constant = w + 25 + 24
    }
    
    private func setDownvotesCount(count: Int) {
        let text = "\(count) "
        let w = text.width(withConstrainedHeight: 100, font: .b3())
        downvoteBtn.setTitle(text, for: .normal)
        self.layoutIfNeeded()
        downvoteWidth?.constant = w + 25 + 24
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
