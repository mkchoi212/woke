//
//  UIColor+Polarity.swift
//  woke
//
//  Created by Mike Choi on 11/25/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(polarity: Double) {
        switch polarity {
        case 0.0 ... 0.9:
            self.init(red: 0, green: 122, blue: 255)
        case 1.0 ... 1.9:
            self.init(red: 90, green: 200, blue: 250)
        case 2.0 ... 2.9:
            self.init(red: 76, green: 217, blue: 100)
        case 3.0 ... 3.9:
            self.init(red: 88, green: 86, blue: 214)
        case 4.0 ... 5.0:
            self.init(red: 255, green: 59, blue: 48)
        default:
            fatalError("Invalid user score range")
        }
    }
}
