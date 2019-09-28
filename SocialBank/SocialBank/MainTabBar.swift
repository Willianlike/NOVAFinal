//
//  MainTabBar.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainTabBar: UITabBarController {
    
    static func getTabBar() -> UIViewController {
        let tabbar = MainTabBar()
        var vcs = [UIViewController]()
        let vc = IniciativeListingVC(provider: ApiProvider.shared)
        let vc1 = MainNavVC(rootViewController: vc)
        vc1.tabBarItem = UITabBarItem(title: nil, image: Images.home, tag: 1)
        vcs.append(vc1)
        
        
        let vc2 = getDumpVC()
        vc2.tabBarItem = UITabBarItem(title: nil, image: Images.chart, tag: 2)
        vcs.append(vc2)
        
        
        let vc3 = getDumpVC()
        vc3.tabBarItem = UITabBarItem(title: nil, image: Images.book, tag: 3)
        vcs.append(vc3)
        
        
        let vc4 = getDumpVC()
        vc4.tabBarItem = UITabBarItem(title: nil, image: Images.account, tag: 4)
        vcs.append(vc4)
        
        
        tabbar.viewControllers = vcs
        return tabbar
    }
    
    static func getDumpVC() -> UIViewController {
        let json = JSON(parseJSON: BankIniciativeModel.getMock())
        let model = try! BankIniciativeModel(json: json)
        let vc = BankIniciativeVC(model: model)
        return vc
    }
    
}
