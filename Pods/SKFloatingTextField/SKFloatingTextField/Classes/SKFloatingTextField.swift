//
//  SMTextField.swift
//  SmartVCApp
//
//  Created by Sandeep on 01/03/21.
//

import UIKit
@objc public protocol SKFlaotingTextFieldDelegate: UITextFieldDelegate {
    /// it is a delegte method to write a handler for tap on right view, or on the textField if it is set as droppable
    @objc optional func didTapOnRightView(textField: SKFloatingTextField)
    @objc optional func textFieldDidEndEditing(textField : SKFloatingTextField)
    @objc optional func textFieldDidChangeSelection(textField: SKFloatingTextField)
    @objc optional func textFieldDidBeginEditing(textField: SKFloatingTextField)
}
public class SKFloatingTextField : UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bottomErrorLabel: UILabel!
    
    private var rightViewTapAction : ( (UIButton) -> () )?
    /**
     *Member Variables
     **/
    /// isValidInput : make it true if the text field content is valid according to the user input validation else  take it false to work better with error label
    public var isValidInput : Bool = false
    
    public var rightView:UIView?{
        get{
            return self.textField.rightView
        }
        set{
            self.textField.rightView = newValue
        }
    }
    
    public var keyBoardType : UIKeyboardType? {
        get{
            return self.textField.keyboardType
        }
        set{
            self.textField.keyboardType = newValue!
        }
    }
    public var isSecureTextInput: Bool {
        set{
            self.textField.isSecureTextEntry = newValue
        }
        get{
            return self.textField.isSecureTextEntry
        }

    }
    public var text: String? {
        get{
            return textField.text
        }set{
            textField.text = newValue
        }
    }
    public var textColor : UIColor? {
        get{
            return textField.textColor
        }set{
            textField.textColor = newValue
        }
    }
    public var placeholder: String?{
        set{
            textField.attributedPlaceholder = NSAttributedString(string: newValue!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 21/255, green: 114/255, blue: 161/255, alpha: 1.0)])
        }
        get{
            return textField.placeholder
        }
    }
    public override var inputView: UIView? {
        set{
            textField.inputView = newValue
        }get{
            return textField.inputView
        }
    }
    public var delegate: UITextFieldDelegate?{
        set{
            textField.delegate = newValue
        }
        get{
            return textField.delegate
        }
    }
    public var floatingLabelText : String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    public var floatingLabelColor : UIColor? {
        set {
            self.titleLabel.textColor = newValue
        }
        get{
            return self.titleLabel.textColor
        }
    }
    public var errorLabelText : String? {
        set{
            self.bottomErrorLabel.text = newValue
            if newValue?.count ?? 0 > 0 {
                self.textField.layer.borderColor = self.errorLabelColor.cgColor
                self.titleLabel.textColor = self.errorLabelColor
                self.bottomErrorLabel.isHidden = false
            }else{
                self.textField.layer.borderColor = self.borderColor.cgColor
                self.titleLabel.textColor = self.floatingLabelColor
                self.bottomErrorLabel.isHidden = true
            }
        }
        get{
            return self.bottomErrorLabel.text
        }
    }
    public var errorLabelColor : UIColor {
        set{
            self.bottomErrorLabel.textColor = newValue
        }
        get{
            return self.bottomErrorLabel.textColor
        }
    }
    
    public var borderColor : UIColor  =  .init(red: 21/255, green: 114/255, blue: 161/255, alpha: 1.0)
    public var activeBorderColor : UIColor?
    
    public var floatingLabelFont : UIFont = UIFont.systemFont(ofSize: 12, weight: .regular) {
        didSet{
            self.titleLabel.font = self.floatingLabelFont
        }
    }
    public var textFieldFont : UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold) {
        didSet{
            self.textField.font = self.textFieldFont
        }
    }
    public var errorLabelFont : UIFont = UIFont.systemFont(ofSize: 12, weight: .regular){
        didSet{
            self.bottomErrorLabel.font = self.errorLabelFont
        }
    }
    public var bgColor : UIColor? {
        didSet{
            self.contentView.backgroundColor = self.bgColor
            self.textField.backgroundColor = self.bgColor
            self.bottomErrorLabel.backgroundColor = self.bgColor
            self.titleLabel.backgroundColor = self.bgColor
        }
    }
    public var borderWidth : CGFloat = 1 {
        didSet{
            self.textField.layer.borderWidth = self.borderWidth
        }
    }
    public var cornerRadius : CGFloat? {
        didSet{
            self.textField.layer.cornerRadius = self.cornerRadius ?? 0
        }
    }
    public var textAlignment : NSTextAlignment = .left{
        didSet{
            self.textField.textAlignment = self.textAlignment
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commoninit()
    }
    
    /// Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    
    private func commoninit(){
        Bundle(identifier: "org.cocoapods.SKFloatingTextField")?.loadNibNamed("SKFloatingTextField", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.textField.placeholder = nil
        self.titleView.isHidden = true
        self.bottomErrorLabel.isHidden = true
        self.textField.layer.borderColor = self.borderColor.cgColor
        self.borderWidth = 1
        self.floatingLabelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.textFieldFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.errorLabelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.titleLabel.textAlignment = .left
        self.floatingLabelColor = .init(red: 21/255, green: 114/255, blue: 161/255, alpha: 1.0)
        self.textColor = .init(red: 21/255, green: 114/255, blue: 161/255, alpha: 1.0)
        self.bottomErrorLabel.textAlignment = .left
        self.isSecureTextInput = false
        self.setLeftImage(image: UIImage(), tintColor: .lightGray)
        self.bgColor = .white
        self.activeBorderColor = self.borderColor
        
        //text field editing action
        self.textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
        
    }
    /**
     Member Methods
     ***/
    
    /// Setting some common text Field UI Designs
    /// Circular corner radius
    public func setCircularTFUI(){
        self.cornerRadius = self.textField.layer.frame.size.height/2
    }
    /// having only bottom border
    public func setOnlyBottomBorderTFUI(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.textField.frame.size.height - 1, width: self.textField.frame.size.width, height: 1.0)
        bottomLine.backgroundColor = self.borderColor.cgColor
        self.textField.borderStyle = .none
        self.textField.layer.borderWidth = 0
        self.textField.layer.masksToBounds = true
        self.textField.layer.addSublayer(bottomLine)
    }
    /// Round Text field
    public func setRoundTFUI(){
        self.cornerRadius = 5
    }
    ///Rectangular text field
    public func setRectTFUI(){
        self.cornerRadius = 0
    }
    
    /// set droppable if you have to put action on tap gesture on the entire textField the acton will be performed using didtaponRightView delegate method
    public func setDroppable(){
        self.textField.isSecureTextEntry = false
        self.textField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didtapOnRightView))
        self.addGestureRecognizer(tap)
    }
    
    /// Set left side image in the textField
    public func setLeftImage(image : UIImage,tintColor : UIColor){
        let iconView = UIImageView(frame:CGRect(x: 10, y: 10, width: 13, height: 11))
        iconView.image = image
        iconView.tintColor = tintColor
        let iconContainerView: UIView = UIView(frame:CGRect(x: 30, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        self.textField.leftView = iconContainerView
        self.textField.leftViewMode = .always
    }
    
    /// Set right side image like password secure / non secure button view with its action
    public func setRightView(image : UIImage, tintColor : UIColor,action: ( (UIButton) -> () )?){
        self.rightViewTapAction = action
        let iconView = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 14))
        iconView.setImage(image, for: .normal)
        iconView.tintColor = tintColor
        let iconContainerView: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        self.textField.rightView = iconContainerView
        self.textField.rightViewMode = .always
        iconView.addTarget(self, action: #selector(didtapOnRightView), for: .touchUpInside)
    }
    
    @objc private func didtapOnRightView(){
        guard let rightview = self.textField.rightView?.subviews.first as? UIButton else { return }
        rightViewTapAction?(rightview)
        (self.delegate as? SKFlaotingTextFieldDelegate)?.didTapOnRightView?(textField: self)
    }
    
    public func showTitle(){
        self.titleView.isHidden = false
    }
    
    public func hideTitle(){
        self.titleView.isHidden = true
    }
    
    public func showError(){
        self.bottomErrorLabel.isHidden = false
    }
    public func hideError(){
        self.bottomErrorLabel.isHidden = true
    }
    
}
extension SKFloatingTextField{
    @objc fileprivate func textFieldDidEndEditing() {
        if self.textField.text == "" {
            self.placeholder = self.floatingLabelText
            self.hideTitle()
        }else if self.isValidInput {
            self.errorLabelText = ""
        }
        if let _ = self.activeBorderColor {
            self.textField.layer.borderColor = self.borderColor.cgColor
            self.floatingLabelColor = self.borderColor
        }
        (self.delegate as? SKFlaotingTextFieldDelegate)?.textFieldDidEndEditing?(textField: self)
    }
    @objc fileprivate func textFieldDidBeginEditing() {
        self.showTitle()
        self.placeholder = ""
        if let color = self.activeBorderColor {
            self.textField.layer.borderColor = color.cgColor
            self.floatingLabelColor = color
        }
        (self.delegate as? SKFlaotingTextFieldDelegate)?.textFieldDidBeginEditing?(textField: self)
    }
    @objc fileprivate func textFieldDidChangeSelection() {
        self.placeholder = ""
        self.showTitle()
        self.errorLabelText = ""
        if let color = self.activeBorderColor {
            self.textField.layer.borderColor = color.cgColor
            self.floatingLabelColor = color
        }
        (self.delegate as? SKFlaotingTextFieldDelegate)?.textFieldDidChangeSelection?(textField: self)
    }
}
