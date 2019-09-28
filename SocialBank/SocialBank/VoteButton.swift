//
//  VoteButton.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit

class VoteButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
//            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            contentEdgeInsets = .zero
            semanticContentAttribute = .forceRightToLeft
        }
    }
}
