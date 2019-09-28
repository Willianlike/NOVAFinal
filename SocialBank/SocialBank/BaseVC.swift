//
//  BaseVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class BaseVC: UIViewController {
    
    let topView = BaseTopView()
    let containerView = UIView()
    let scrollView = UIScrollView()
    let scrollContainer = UIView()
    let backBtn = UIButton(type: .system)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let topContainer = UIView()
        let topBack = UIImageView()
        topContainer.addSubview(topBack)
        topContainer.addSubview(topView)
        view.addSubview(topContainer)
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        scrollView.contentInset.top = 20
        
        containerView.layer.cornerRadius = 40
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        
        topBack.image = Images.barBack
        
        topView.backBtn.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        constrain(view, topContainer, topBack, topView, containerView, scrollView, scrollContainer)
        { (view, topContainer, topBack, topView, containerView, scrollView, scrollContainer) in
            topBack.edges == topContainer.edges
            topView.edges == inset(topContainer.edges, UIApplication.shared.statusBarFrame.height, 0, 40, 0)
            
            topContainer.top == view.top
            topContainer.leading == view.leading
            topContainer.trailing == view.trailing
            
            containerView.top == topContainer.bottom - 40
            containerView.leading == view.leading
            containerView.trailing == view.trailing
            containerView.bottom == view.bottom
            
            scrollView.edges == containerView.edges
            scrollContainer.edges == scrollView.edges
            scrollContainer.width == scrollView.width
        }
    }
    
}
