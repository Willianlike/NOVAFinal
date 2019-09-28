//
//  BankIniciativeVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage

class BankIniciativeVC: BaseVC {
    
    let scrollView = UIScrollView()
    let scrollContainer = UIView()
    let container = UIStackView()
    
    let titleLabel = UILabel()
    let image = UIImageView()
    let descriptionView = UITextView()
    var descriptionHeight: NSLayoutConstraint?
    let votesView = VotesStackView()
    let pollBtn = UIButton(type: .system)
    
    let model: BankIniciativeModel
    
    init(model: BankIniciativeModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupModel()
    }
    
    func setupScroll() {
        view.addSubview(scrollView)
        scrollContainer.addSubview(container)
        scrollView.addSubview(scrollContainer)
        constrain(view, scrollView, container, scrollContainer)
        { (view, scrollView, container, scrollContainer) in
            scrollView.edges == view.edges
            container.edges == inset(scrollContainer.edges, 16, 16, 16, 16)
            scrollContainer.edges == scrollView.edges
            scrollContainer.width == scrollView.width
        }
    }
    
    func setupUI() {
        setupScroll()
        
        container.alignment = .center
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.spacing = 16
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(image)
        container.addArrangedSubview(descriptionView)
        container.addArrangedSubview(votesView)
        container.addArrangedSubview(pollBtn)
        
        constrain(container, titleLabel, image, descriptionView, votesView, pollBtn)
        { (container, titleLabel, image, descriptionView, votesView, pollBtn) in
            titleLabel.width == container.width
            image.width == container.width
            descriptionView.width == container.width
            pollBtn.width == container.width
            
            image.height == image.width / 2
            
            pollBtn.height == 52
        }
        
        descriptionHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        descriptionHeight?.isActive = true
        
        titleLabel.font = .b1(.bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .blue
        
        image.layer.cornerRadius = 30
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        descriptionView.font = .b3()
        descriptionView.isEditable = false
        descriptionView.isScrollEnabled = false
        
        pollBtn.setTitle("Пройти опрос", for: .normal)
        pollBtn.setTitleColor(.white, for: .normal)
        pollBtn.backgroundColor = .orange
        pollBtn.titleLabel?.font = .b2()
        pollBtn.layer.cornerRadius = 10
        
        
    }
    
    func setupModel() {
        titleLabel.text = model.title
        image.setUrlImage(url: model.image)
        descriptionView.text = model.description
        descriptionHeight?.constant = descriptionView.contentSize.height
        votesView.upvoteCount = model.upvotes
        votesView.downvoteCount = model.downvotes
        votesView.voteStatus = model.voteStatus
    }
    
}
