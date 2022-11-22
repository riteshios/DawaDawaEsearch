//
//  UIImageViewCornerRadius.swift
//  TheBeaconApp
//
//  Created by Ruchin Singhal on 04/11/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import UIKit

class UIImageViewCornerRadius: UIImageViewBorderWidthAndColor {
  @IBInspectable override var cornerRadius: CGFloat {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  @IBInspectable var asPerWidthCornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = (asPerWidthCornerRadius * kScreenWidth) / 320
      layer.masksToBounds = asPerWidthCornerRadius > 0
    }
  }
  @IBInspectable var makeCircle: Bool = false {
    didSet {
      layer.masksToBounds = cornerRadius > 0
    }
  }
}


extension UIImageView {
    func seeFullImage() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else{
            return
        }
        guard let im = imageView.image else {
            return
        }
        
        let newImageView = UIImageView(image: im)
        let frame = self.window!.convert(imageView.frame, from:imageView)
        //        new_img = frame
        newImageView.frame = frame
        if #available(iOS 11.0, *) {
            newImageView.accessibilityFrame = frame
        } else {
            newImageView.accessibilityFrame = frame
            // Fallback on earlier versions
        }
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        let tap = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
//        tap.direction = .up
        self.window!.addSubview(newImageView)
        
        UIView.animate(withDuration: 0.5, animations: {
            newImageView.frame = UIScreen.main.bounds
        }) { (_) in
            newImageView.frame = UIScreen.main.bounds
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        self.window!.addSubview(newImageView)
        let f = imageView.accessibilityFrame
        UIView.animate(withDuration: 0.5, animations: {
            newImageView.frame = f
        }) { (_) in
            newImageView.removeFromSuperview()
        }
    }
}
