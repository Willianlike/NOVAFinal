//
//  DiscussionVC.swift
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
import InputBarAccessoryView

class DiscussionVC: BaseVC, InputBarAccessoryViewDelegate {
    
    let inputBar = iMessageInputBar()
    private var keyboardManager = KeyboardManager()
    
    let comments = BehaviorRelay<[DiscussionModel]>(value: [])
    
    let collection = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    let model: BankIniciativeModel
    let provider = ApiProvider.shared
    
    let sendMessage = PublishSubject<SendCommentRequest>()
    let requestComments = PublishSubject<Void>()
    
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
    
    func setupUI() {
        inputBar.delegate = self
        view.addSubview(inputBar)
        inputBar.inputTextView.placeholder = "Напишите сообщение"
        
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: collection)
        
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.collection.contentInset.bottom = barHeight + notification.endFrame.height
            self?.collection.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.collection.contentInset.bottom = barHeight
                self?.collection.scrollIndicatorInsets.bottom = barHeight
        }
        collection.keyboardDismissMode = .interactive
        
        let text = NSMutableAttributedString(string: model.title,
                                             attributes: [NSAttributedString.Key.font : UIFont.b1(.bold)])
        text.append(NSAttributedString(string: "\n\nОбсуждение инициативы",
                                       attributes: [NSAttributedString.Key.font : UIFont.b3()]))
        topView.title.attributedText = text
        
        collection.register(DiscussionCollectionCell.self, forCellWithReuseIdentifier: DiscussionCollectionCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset.top = 20
        collection.contentInset.bottom = 60
        
        containerView.addSubview(collection)
        collection.backgroundColor = .white
        constrain(containerView, collection) { (cont, collection) in
            collection.edges == cont.edges
        }
    }
    
    func setupModel() {
        HUD.show(.progress)
        comments.asObservable().subscribe(onNext: { [unowned self] _ in
            self.collection.reloadData()
            }).disposed(by: disposeBag)
        
        requestComments.asObservable().flatMap { [unowned self] in
            self.provider.getIniciativeComments(request: IniciativeCommentsRequest(id: self.model.id))
        }
        .subscribe(onNext: { [unowned self] result in
            self.resultCommentsHandle(result: result)
        }).disposed(by: disposeBag)
        
        sendMessage.asObservable()
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .flatMap { [unowned self] in
            self.provider.sendComment(request: $0)
        }
        .subscribe(onNext: { [unowned self] result in
            self.resultSendCommentHandle(result: result)
            }).disposed(by: disposeBag)
        
        requestComments.onNext(())
    }
    
    func resultCommentsHandle(result: ApiProvider.IniciativeCommentsResult) {
        HUD.hide()
        switch result {
        case let .success(response):
            comments.accept(response.comments)
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
    }
    
    func resultSendCommentHandle(result: ApiProvider.SendCommentResult) {
        HUD.hide()
        switch result {
        case let .success(response):
            if !response.success {
                HUD.flash(.label(NError.iniciativeFull.localizedDescription), delay: 1)
            } else {
                requestComments.onNext(())
                inputBar.inputTextView.text = ""
            }
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.isEmpty else { return }
        let reply: Int? = comments.value.first(where: { $0.replyTo })?.id
        let request = SendCommentRequest(id: model.id, replyTo: reply, text: text)
        sendMessage.onNext(request)
    }
    
}

extension DiscussionVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscussionCollectionCell.reuseIdentifier, for: indexPath) as! DiscussionCollectionCell
        let item = comments.value[indexPath.row]
        cell.setup(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var newComms = comments.value
        for i in newComms.indices {
            if i == indexPath.row {
                newComms[i].replyTo = !newComms[i].replyTo
            } else {
                newComms[i].replyTo = false
            }
        }
        comments.accept(newComms)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width - 32
        let item = comments.value[indexPath.row]
        return CGSize(width: w, height: DiscussionCollectionCell.getHeight(w: w, item: item))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
}
