//
//  RatingCircleView.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 29/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography
import MBCircularProgressBar

class RatingCircleView: UIView {
    
    let circle: MBCircularProgressBarView = {
        let l = MBCircularProgressBarView()
        l.maxValue = 10
        l.progressAngle = 100
        l.progressLineWidth = 10
        l.emptyLineWidth = 10
        l.progressCapType = 0
        l.emptyLineColor = UIColor.black.withAlphaComponent(0.1)
        l.backgroundColor = .clear
        l.valueFontSize = 16
        l.showUnitString = false
        l.emptyLineStrokeColor = .clear
        l.progressStrokeColor = .clear
        l.progressColor = .cirlce
        l.fontColor = .cirlce
        return l
    }()
    
    let label = UILabel()
    
    init() {
        super.init(frame: CGRect())
        addSubview(circle)
        addSubview(label)
        
        label.font = .c1(.semibold)
        label.textColor = .cirlce
        label.text = "Рейтинг"
        label.textAlignment = .center
        
        constrain(circle, self, label) { (circle, view, label) in
            circle.top == view.top
            circle.leading == view.leading
            circle.trailing == view.trailing
            circle.height == circle.width
            
            label.top == circle.bottom
            label.leading == view.leading
            label.trailing == view.trailing
            label.bottom == view.bottom
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
