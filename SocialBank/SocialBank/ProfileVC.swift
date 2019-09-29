//
//  ProfileVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class ProfileVC1: UIViewController {
    let scroll: UIScrollView = {
        let v = UIScrollView()
        return v
    }()

    let image: UIImageView = {
        let v = UIImageView(image: UIImage(named: "profileScreen"))
        v.contentMode = .scaleAspectFit
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        scroll.addSubview(image)
        let im = image.image!
        constrain(image, scroll, view) { (image, scroll, view) in
            image.edges == scroll.edges
            scroll.edges == view.edges
            image.width == UIScreen.main.bounds.width
            image.height == im.size.height * (UIScreen.main.bounds.width / im.size.width)
        }
        view.backgroundColor = .white
    }
    
}

class ScrollVC: UIViewController {
    let scroll = UIScrollView()

    let image = UIImageView()
    let img: UIImage
    
    let close = UIButton(type: .system)
    
    init(image: UIImage) {
        img = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        view.addSubview(close)
        scroll.addSubview(image)
        
//        close.setImage(UIImage(named: "back_filled"), for: .normal)
        close.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        close.frame = .init(x: 24, y: 80, width: 100, height: 100)
        close.tintColor = .white
        
        image.contentMode = .scaleAspectFit
        image.image = img
        
        constrain(image, scroll, view) { (image, scroll, view) in
            image.edges == scroll.edges
            scroll.edges == view.edges
            image.width == UIScreen.main.bounds.width
            image.height == img.size.height * (UIScreen.main.bounds.width / img.size.width)
        }
        view.backgroundColor = .white
    }
    
}
