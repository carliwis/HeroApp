//
//  Extensions.swift
//  HeroApp
//
//  Created by Carlos Osuna on 18/02/21.
//

import UIKit

extension UIView {
    
    func setShadow(offset: CGSize? = CGSize(width: 0,height: 2), shadowRadius: CGFloat? = 1.2,
                          colorAlpha: CGFloat? = 0.6, shadowOpacity: Float? = 0.3) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(colorAlpha!).cgColor
        self.layer.shadowOpacity = shadowOpacity!
        self.layer.shadowRadius = shadowRadius!
        self.layer.shadowOffset = offset!
    }
}

extension String {
    
    func replace(string:String, replacement:String) -> String {
            return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
  }
