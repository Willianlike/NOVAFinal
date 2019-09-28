//
//  Fonts.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func h1(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 40, weight: weight)
    }
    
    static func largeTitle(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 34, weight: weight)
    }
    
    static func h2(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 28, weight: weight)
    }
    
    static func h3(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 24, weight: weight)
    }
    
    static func h4(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 22, weight: weight)
    }
    
    static func b1(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 20, weight: weight)
    }
    
    static func b2(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: weight)
    }
    
    static func b3(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: weight)
    }
    
    static func c1(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 13, weight: weight)
    }
    
    static func c2(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 11, weight: weight)
    }
    
    static func t1(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: weight)
    }
    
    static func t2(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 13, weight: weight)
    }
    
    static func t3(_ weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: 11, weight: weight)
    }
}
