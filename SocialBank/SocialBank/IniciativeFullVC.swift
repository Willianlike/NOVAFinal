//
//  IniciativeFullVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography
import PKHUD

class IniciativeFullVC: UIViewController {
    
    let scrollView = UIScrollView()
    let scrollContainer = UIView()
    let container = UIStackView()
    
    let dateLabel = UILabel()
    let descriptionView = UITextView()
    let voteView = VotesStackView()
    
    let iniModel: BankIniciativeModel
    let provider: ApiProvider
    
    let questions = BehaviorRelay<[QuestionModel]>(value: [])
    let requestAnswers = PublishSubject<AnswerRequest>()
    
    let disposeBag = DisposeBag()
    
    init(model: BankIniciativeModel, provider: ApiProvider) {
        iniModel = model
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScroll() {
        view.backgroundColor = .white
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
        
        dateLabel.font = .b3()
        dateLabel.textColor = .primaryText
        dateLabel.text = "date"
        
        descriptionView.font = .b3()
        descriptionView.isScrollEnabled = false
        descriptionView.textColor = .primaryText
        descriptionView.text = iniModel.description
        
        let voteContainer = UIView()
        voteContainer.addSubview(voteView)
        constrain(voteContainer, voteView) { (voteContainer, voteView) in
            voteView.top == voteContainer.top
            voteView.bottom == voteContainer.bottom
            voteView.trailing == voteContainer.trailing
            voteView.leading >= voteContainer.leading
        }
        voteView.voteStatus = iniModel.voteStatus
        voteView.downvoteCount = iniModel.downvotes
        voteView.upvoteCount = iniModel.upvotes
        
        container.alignment = .center
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.spacing = 8
        
        container.addArrangedSubview(dateLabel)
        container.addArrangedSubview(descriptionView)
        container.addArrangedSubview(voteContainer)
        
        constrain(dateLabel, descriptionView, voteContainer, container)
        { (dateLabel, descriptionView, voteContainer, container) in
            dateLabel.width == container.width
            descriptionView.width == container.width
            voteContainer.width == container.width
        }
        
    }
    
    func setupModel() {
        HUD.show(.progress)
        provider.getIniciativeFull(request: IniciativeFullRequest(id: iniModel.id))
            .subscribe(onNext: { [unowned self] result in
                self.recieveResponse(result: result)
            }).disposed(by: disposeBag)
        
        questions.debug().subscribe(onNext: { [unowned self] questions in
            self.questionsSetup(questions: questions)
            }).disposed(by: disposeBag)
        
        requestAnswers.asObservable()
            .flatMap({ [unowned self] (request) in
                self.provider.postAnswer(request: request, iniciativeId: self.iniModel.id)
            })
            .subscribe().disposed(by: disposeBag)
        
        scrollView.setKeyboardInset()
    }
    
    func questionsSetup(questions: [QuestionModel]) {
        for (i, questionVM) in questions.enumerated() {
            let (questitionView, subject) = questionVM.getView()
            container.addArrangedSubview(questitionView)
            
            constrain(questitionView, container)
            { (questitionView, container) in
                questitionView.width == container.width
            }
            
            if i != questions.count - 1 {
                questitionView.addBorders(edges: .bottom)
            }
            
            subject.asObservable().bind(to: requestAnswers).disposed(by: disposeBag)
        }
    }
    
    func recieveResponse(result: ApiProvider.IniciativeFullResult) {
        HUD.hide()
        switch result {
        case let .success(response):
            questions.accept(response.questions)
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
    }
    
}
