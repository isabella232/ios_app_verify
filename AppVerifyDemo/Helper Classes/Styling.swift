//
//  Styling.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/18/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var TSBlue: UIColor {
        return UIColor(red: 0/255, green: 82/255, blue: 232/255, alpha: 1.0)
    }
    
    class var TSGreen: UIColor {
        return UIColor(red: 175/255, green: 203/255, blue: 8/255, alpha: 1.0)
    }
    
    class var TSTextGray: UIColor {
        return UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
    }
}

enum ButtonColor {
    case requestSMS
    case confirmCode
}

class Button: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    
    init(title: String, color: ButtonColor) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        
        switch color {
        case .requestSMS:
            backgroundColor = .TSBlue
        case .confirmCode:
            backgroundColor = .TSGreen
        }
        
        applyStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyling() {
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
    }
}
