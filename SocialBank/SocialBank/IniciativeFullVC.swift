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

class IniciativeFullVC: BaseVC {
    
    let discussBtn = UIButton(type: .system)
    let discussBtn1 = UIButton(type: .system)
    
    let container = UIStackView()
    
    let dateLabel = UILabel()
    let descriptionView = UITextView()
    let voteView = VotesStackView()
    
    let iniModel: BankIniciativeModel
    let provider: ApiProvider
    
    let questions = BehaviorRelay<[QuestionModel]>(value: [])
    let requestAnswers = PublishSubject<AnswerRequest>()
    let voteChanged = PublishSubject<VoteChanged>()
    
    init(model: BankIniciativeModel, provider: ApiProvider) {
        iniModel = model
        self.provider = provider
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
        scrollContainer.addSubview(container)
        constrain(view, scrollView, container, scrollContainer)
        { (view, scrollView, container, scrollContainer) in
            container.edges == inset(scrollContainer.edges, 16, 16, 16, 16)
        }
    }
    
    func setupUI() {
        setupScroll()
        
        let text = NSMutableAttributedString(string: iniModel.title,
                                             attributes: [NSAttributedString.Key.font : UIFont.b1(.bold)])
        
        topView.title.attributedText = text
        
        dateLabel.font = .b3()
        dateLabel.textColor = .primaryText
        dateLabel.text = iniModel.dateText
        
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
        
        view.addSubview(discussBtn)
        discussBtn.setImage(Images.golosovanie, for: .normal)
        view.addSubview(discussBtn1)
        discussBtn1.setTitle("Обсудить", for: .normal)
        discussBtn1.tintColor = .orange
        
        constrain(view, discussBtn, discussBtn1, containerView)
        { (view, discussBtn, discussBtn1, containerView) in
            discussBtn.trailing == view.trailing - 32
            discussBtn.centerY == containerView.top
            discussBtn.width == 60
            discussBtn.height == 60
            
            discussBtn1.centerX == discussBtn.centerX
            discussBtn1.top == discussBtn.bottom - 16
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
        
        voteView.voteStatusChanged.asObservable().map { [unowned self] in (self.iniModel.id, $0) }
            .bind(to: voteChanged).disposed(by: disposeBag)
            
            discussBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.openDiscuss()
            }).disposed(by: disposeBag)
            
            discussBtn1.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.openDiscuss()
            }).disposed(by: disposeBag)
    }
    
    func openDiscuss() {
        let vc = DiscussionVC(model: iniModel)
        if let appNav = appNavigationVC {
            appNav.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
