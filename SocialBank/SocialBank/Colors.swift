//
//  Colors.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit

extension UIColor {
    static let primaryText = UIColor.init(hexString: "#555555")
    static let border = UIColor.init(hexString: "#e0e0e0")
    static let upvote = UIColor.init(hexString: "#27ae60")
    static let downvote = UIColor.init(hexString: "#FC5C5E")
    static let voteText = UIColor.init(hexString: "#FFFFFF")
    static let topBarText = UIColor.init(hexString: "#FFFFFF")
    static let segmentActive = UIColor.init(hexString: "#FFFFFF")
    static let segmentInactive = UIColor.segmentActive.withAlphaComponent(0.6)
    static let fieldActive = UIColor.init(hexString: "#1489B9")
}
