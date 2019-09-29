//
//  Images.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit

struct Images {
    static var pic: UIImage? {
        return UIImage(named: "pic")
    }
    static var upvote: UIImage? {
        return UIImage(named: "upvote")
    }
    static var downvote: UIImage? {
        return UIImage(named: "downvote")
    }
    static var home: UIImage? {
        return UIImage(named: "home")
    }
    static var book: UIImage? {
        return UIImage(named: "book")
    }
    static var chart: UIImage? {
        return UIImage(named: "chart")
    }
    static var account: UIImage? {
        return UIImage(named: "account")
    }
    static var search: UIImage? {
        return UIImage(named: "search")
    }
    static var barBack: UIImage? {
        if profileKind == .person {
            return UIImage(named: "barBack")
        } else {
            return UIImage(named: "barBackBusines")
        }
    }
    static var mail: UIImage? {
        return UIImage(named: "mail")
    }
    static var password: UIImage? {
        return UIImage(named: "password")
    }
    static var bankLogo: UIImage? {
        return UIImage(named: "bankLogo")
    }
    
    
    static var check_empty: UIImage? {
        return UIImage(named: "check_empty")
    }
    static var check_selected: UIImage? {
        return UIImage(named: "check_selected")
    }
    static var radio_empty: UIImage? {
        return UIImage(named: "radio_empty")
    }
    static var radio_selected: UIImage? {
        return UIImage(named: "radio_selected")
    }
    static var star_empty: UIImage? {
        return UIImage(named: "star_empty")
    }
    static var star_selected: UIImage? {
        return UIImage(named: "star_selected")
    }
    static var back: UIImage? {
        return UIImage(named: "back")
    }
    static var profile_hint: UIImage? {
        return UIImage(named: "profile_hint")
    }
    static var golosovanie: UIImage? {
        return UIImage(named: "golosovanie")
    }
    static var send: UIImage? {
        return UIImage(named: "send")
    }
    static var reply: UIImage? {
        return UIImage(named: "reply")
    }
    static var lock: UIImage? {
        return UIImage(named: "lock")
    }
    static var chevron: UIImage? {
        return UIImage(named: "chevron")
    }
    static var phone: UIImage? {
        return UIImage(named: "phone")
    }
}
