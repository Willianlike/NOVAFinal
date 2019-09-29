//
//  VCExtensions.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography

extension UIImageView {
    
    func setUrlImage(url: String?, placeholder: UIImage? = nil) {
        if let pl = placeholder {
            image = pl
        }
        guard let url = url, let Url = URL(string: url) else { return }
        self.sd_setImage(with: Url, placeholderImage: placeholder)
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIScrollView {
    @objc func setKeyboardInset() {
        let oldInset = contentInset
        
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [unowned self] notification in
                let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
                self.contentInset.bottom = keyboardHeight
            })
        
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [unowned self] _ in
                self.contentInset = oldInset
            })
    }
}


func setEqualW(_ view: UIView, views: UIView...) {
    for i in views {
        constrain(view, i) { (view, i) in
            i.width == view.width
        }
    }
}

extension UIView {
    
    func applyShadow(height: CGFloat = 3, radius: CGFloat = 20,
                     opacity: Float = 0.2, color: UIColor = .primaryText) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = height
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor = .border,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
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

extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
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
