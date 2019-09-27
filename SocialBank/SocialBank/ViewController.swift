//
//  ViewController.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let kek = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(kek)
        kek.backgroundColor = .green
        kek.frame = view.bounds
        // Do any additional setup after loading the view.
    }


}

