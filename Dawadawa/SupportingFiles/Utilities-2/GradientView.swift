import UIKit

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var cRadius: CGFloat = 42
    @IBInspectable var sOffsetWidth: Int = 0
    @IBInspectable var sOffsetHeight: Int = 3
    @IBInspectable var sColor: UIColor? = .black
    @IBInspectable var sOpacity: Float = 1

    override func layoutSubviews() {
        layer.cornerRadius = cRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cRadius)
        layer.masksToBounds = false
        layer.shadowColor = sColor?.cgColor
        layer.shadowOffset = CGSize(width: sOffsetWidth, height: sOffsetHeight)
        layer.shadowOpacity = sOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}
