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
    
    let comments = BehaviorRelay<[DiscussionModel]>(value: [])
    
    let collection = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    let model: BankIniciativeModel
    let provider = ApiProvider.shared
    
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
        
        let text = NSMutableAttributedString(string: model.title,
                                             attributes: [NSAttributedString.Key.font : UIFont.b1(.bold)])
        text.append(NSAttributedString(string: "\n\nОбсуждение инициативы",
                                       attributes: [NSAttributedString.Key.font : UIFont.b3()]))
        topView.title.attributedText = text
        
        collection.register(DiscussionCollectionCell.self, forCellWithReuseIdentifier: DiscussionCollectionCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset.top = 20
        
        containerView.addSubview(collection)
        collection.backgroundColor = .white
        constrain(containerView, collection, inputBar, view) { (cont, collection, inputBar, view) in
            collection.edges == cont.edges
            inputBar.leading == view.leading
            inputBar.trailing == view.trailing
            inputBar.bottom == view.bottom
        }
    }
    
    func setupModel() {
        HUD.show(.progress)
        comments.asObservable().subscribe(onNext: { [unowned self] _ in
            self.collection.reloadData()
            }).disposed(by: disposeBag)
        
        provider.getIniciativeComments(request: IniciativeCommentsRequest(id: model.id))
            .subscribe(onNext: { [unowned self] result in
                self.resultHandle(result: result)
                }).disposed(by: disposeBag)
    }
    
    func resultHandle(result: ApiProvider.IniciativeCommentsResult) {
        HUD.hide()
        switch result {
        case let .success(response):
            comments.accept(response.comments)
        case let .failure(err):
            HUD.flash(.label(err.localizedDescription), delay: 1)
        }
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
