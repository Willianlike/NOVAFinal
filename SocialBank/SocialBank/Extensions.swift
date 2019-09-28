//
//  VCExtensions.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func setUrlImage(url: String?) {
        guard let url = url, let Url = URL(string: url) else { return }
        self.sd_setImage(with: Url, completed: nil)
    }
    
}

extension UIColor {
    @objc convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 & 0xF) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIViewController {
    
    enum AlertTypes {
        case dismissAlert
        case popVC
    }
    
    func showAlert(message: String?, type: AlertTypes = .dismissAlert, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch type {
        case .dismissAlert:
            alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
        case .popVC:
            alert.addAction(UIAlertAction(title: "Ок", style: .default) { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String?, type: AlertTypes = .dismissAlert,
                        title: String? = "Произошла ошибка") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch type {
        case .dismissAlert:
            alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
        case .popVC:
            alert.addAction(UIAlertAction(title: "Ок", style: .default) { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension UserDefaults {
    var authToken: String? {
        get {
            return self.string(forKey: UDKeys.authToken.rawValue)
        }
        set {
            self.set(newValue, forKey: UDKeys.authToken.rawValue)
        }
    }
}
