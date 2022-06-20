//
//  CornerWithShadow.swift
//  WajBatUser
//
//  Created by  on 13/01/22.
//

import Foundation
import UIKit
extension UIView {
    
    func addShadowWithBlurOnView(_ view: UIView?,
                                      spread: CGFloat,
                                      blur: CGFloat,
                                      color: UIColor?,
                                      opacity: Float,
                                      OffsetX: CGFloat,
                                      OffsetY: CGFloat) {
       
       guard let view = view else { return  }
       
       view.layer.shadowOffset = CGSize(width: OffsetX, height: OffsetY)
       view.layer.shadowOpacity = opacity
       //Shadow Color
       if let shadowColor = color {
           view.layer.shadowColor = shadowColor.cgColor
       } else {
           view.layer.shadowColor = nil
       }
       //Shadow Blur
       view.layer.shadowRadius = blur / 2.0
       //Shadow Spread
       if spread == 0 {
           view.layer.shadowPath = nil
       } else {
           let dx = -spread
           let rect = view.bounds.insetBy(dx: dx, dy: dx)
           view.layer.shadowPath = UIBezierPath(rect: rect).cgPath
       }
       view.layer.masksToBounds = false
       view.clipsToBounds = false
   }
    
    
    func drawShadow(cornerRadius:CGFloat = 0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
    }
    
    func applyGradient(isTopBottom: Bool, colorArray: [UIColor]) {
        if let sublayers = layer.sublayers {
            let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isTopBottom {
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //leftRight
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)// vertical gradient start
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradient(isTopBottom: Bool,cornerRadius: CGFloat, colorArray: [UIColor]) {
        if let sublayers = layer.sublayers {
            let _ = sublayers.filter({ $0 is CAGradientLayer }).map({ $0.removeFromSuperlayer() })
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientLayer"
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isTopBottom {
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //leftRight
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)// vertical gradient start
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientlayer() {
        guard let sublayers = self.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        
        for layer in sublayers {
            if layer.name == "GradientLayer"{
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func addShadowView(cornerRadius:CGFloat = 0) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
    }
    func drawBottomShadow() {
        let layer = self.layer
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5);
        layer.shadowOpacity = 0.4;
        layer.shadowRadius = 2.0;
        layer.masksToBounds = false
    }
    
    func overShape() {
        let path = UIBezierPath(ovalIn: self.bounds)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
    }
    
    func setGradientBackground(colorTop:UIColor , colorBottom:UIColor) {
        let gradientLayer = CAGradientLayer()
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        self.layer.insertSublayer(gradientLayer, at:1)    }
    
    func drawBottomShadows() {
          let layer = self.layer
          layer.shadowColor = UIColor.gray.cgColor
          layer.shadowOffset = CGSize(width: 5, height: 5);
          layer.shadowOpacity = 0.4;
          layer.shadowRadius = 2.0;
          layer.masksToBounds = false
      }
}
/*Gradient Color*/
extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor], cornerradius: CGFloat) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil, cornerRadius: cornerradius)
    }
    
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, cornerRadius: CGFloat) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
       // gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        return gradient
    }
    
}


extension UIView {

    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true;

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}

enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}
