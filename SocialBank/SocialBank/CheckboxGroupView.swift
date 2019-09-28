//
//  CheckboxGroupView.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckboxGroupView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    let model: BehaviorRelay<CheckboxGroupModel>
    let tableHeight = BehaviorRelay<CGFloat>(value: 0)
    let answerRequestSubject = PublishSubject<AnswerRequest>()
    
    let disposeBag = DisposeBag()
    
    init(model: CheckboxGroupModel) {
        self.model = BehaviorRelay<CheckboxGroupModel>(value: model)
        super.init(frame: CGRect(), style: .plain)
        setupUI()
        setupModel()
    }
    
    var selfHeight: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.reuseIdentifier)
        rowHeight = UITableView.automaticDimension
        isScrollEnabled = false
        separatorColor = .clear
        estimatedRowHeight = 52
        delegate = self
        dataSource = self
        selfHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        selfHeight?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selfHeight?.constant = contentSize.height
        superview?.layoutIfNeeded()
        tableHeight.accept(contentSize.height)
    }
    
    private func setupModel() {
        model.asObservable().debug().subscribe(onNext: { [unowned self] groups in
            self.reloadData()
        }).disposed(by: disposeBag)
        
        model.asObservable().throttle(ConstantsIniciative.throttle, scheduler: MainScheduler.asyncInstance)
            .map({ $0.buildRequest() })
            .bind(to: answerRequestSubject).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.value.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.model.value.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxCell.reuseIdentifier, for: indexPath) as! CheckboxCell
        cell.setup(item: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newModel = model.value
        newModel.didTapped(index: indexPath.row)
        model.accept(newModel)
    }
    
}
