//
//  UIViewExtensions.swift
//  ListYourDreams
//
//  Created by Maciej Marut on 26.01.2017.
//  Copyright © 2017 Maciej Marut. All rights reserved.
//

import UIKit

private var _shadowEnabled = false
private var _cornerRadius = 0

extension UIView {
    @IBInspectable var enableShadow: Bool {
        get {
            return _shadowEnabled
        } set {
            _shadowEnabled = newValue
            
            if _shadowEnabled {
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3
                self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1).cgColor
            } else {
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var cornerRadius: Int {
        get {
            return _cornerRadius
        } set {
            _cornerRadius = newValue
            self.layer.cornerRadius = CGFloat(_cornerRadius)
        }
    }
}
