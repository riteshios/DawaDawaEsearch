//
//  UIButtonGradiant.swift
//  Abwab
//
//  Created by ABC on 21/03/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class UIButtonGradiant: UIButton {
    @IBInspectable var firstColor:UIColor = UIColor.clear {
        didSet {
            updateVC()
        }
    }
    @IBInspectable var secondColor:UIColor = UIColor.clear {
        didSet {
            updateVC()
        }
    }

    func updateVC() {
        
        let layer = CAGradientLayer()
        layer.colors = [appThemeUp.cgColor,appThemeDown.cgColor]
        layer.frame = self.bounds
        self.layer.insertSublayer(layer, at: 0)
  }

}
