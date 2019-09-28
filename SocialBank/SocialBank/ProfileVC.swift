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
