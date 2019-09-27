//
//  BankIniciativeVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import WebKit

class BankIniciativeVC: UIViewController {
    
    let webView = WKWebView()
    
    init(htmlText: String) {
        super.init(nibName: nil, bundle: nil)
        webView.loadHTMLString(htmlText, baseURL: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
    }
    
}
