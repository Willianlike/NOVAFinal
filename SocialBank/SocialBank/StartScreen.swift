//
//  StartScreen.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Cartography

class StartScreen: UIViewController {
    
    
    let scrollView = UIScrollView()
    
    
    var disposeBag = DisposeBag()
    
    var imgs = [UIView]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        for i in imgs {
            i.frame.size = view.bounds.size
        }
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(2), height: view.bounds.height)
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        
        let img1 = UIImageView()
        let img2 = UIImageView()
        
        let v1 = UIView()
        let v2 = UIView()
        
        let imgs = [v1, v2]
        self.imgs = imgs
        
        v1.addSubview(img1)
        v2.addSubview(img2)
        
        constrain(v1, v2, img1, img2) { (v1, v2, img1, img2) in
        img1.edges == v1.edges
        img2.edges == v2.edges
        }
        
        img1.image = UIImage(named: "per1")
        img2.image = UIImage(named: "per1")
        img1.contentMode = .scaleToFill
        img2.contentMode = .scaleToFill
        
        scrollView.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                self.scrollToNext()
            }).disposed(by: disposeBag)
        
        for i in 0 ..< imgs.count {
            imgs[i].frame = CGRect(x: view.bounds.width * CGFloat(i), y: 0, width: view.bounds.width, height: view.bounds.height - UIApplication.shared.statusBarFrame.height)
            scrollView.addSubview(imgs[i])
        }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
    }
    
    func showLogin() {
        
        let vc = LoginVC(provider: ApiProvider.shared)
        
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func scrollToNext() {
        DispatchQueue.main.async { [unowned self] in
            if self.scrollView.contentSize.width > self.view.bounds.width + self.scrollView.contentOffset.x  {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.view.bounds.width, y: 0), animated: true)
            } else {
                self.showLogin()
            }
        }
    }
    
}

extension StartScreen: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.bounds.width)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
//        if lastIndex != Int(pageIndex),
//            permissions.indices.contains(lastIndex) {
//            switch permissions[lastIndex] {
//            case .geolocation:
//                openLocationPicker(needsToScroll: false)
//            case .pushNotification:
//                UserDefaults.standard.set(true, forKey: UDKeys.pushNotificationsPermissionRecieved.rawValue)
//            default:
//                break
//            }
//            lastIndex = Int(pageIndex)
//        }
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        for i in 0..<(imgs.count - 1) {
            let percentPerOne = CGFloat(0.5)
            let percent = CGFloat(i + 1) * percentPerOne
            if(percentOffset.x > CGFloat(i) * percentPerOne && percentOffset.x <= percent) {
                imgs[i].transform = CGAffineTransform(scaleX: (percent - percentOffset.x) / percentPerOne, y: (percent - percentOffset.x) / percentPerOne)
                imgs[i + 1].transform = CGAffineTransform(scaleX: percentOffset.x / percent, y: percentOffset.x / percent)
                break
            }
        }
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
