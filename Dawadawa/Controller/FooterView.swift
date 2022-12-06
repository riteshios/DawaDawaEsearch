//  FooterView.swift
//  Dawadawa
//  Created by Ritesh Gupta on 29/11/22.

import UIKit
import IQKeyboardManagerSwift

class FooterView: UITableViewHeaderFooterView, UITextViewDelegate{

    @IBOutlet weak var heightButtonReply: NSLayoutConstraint!
    @IBOutlet weak var heightAddPost: NSLayoutConstraint!
    @IBOutlet weak var viewAddPost: UIView!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var textview: IQTextView!
    @IBOutlet weak var buttonPost: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    var callbacktxtviewsubcomment: ((String) -> Void)?
    var callBack:((String)->())?
    func delegate(){
        self.textview.delegate = self
    }
   
    func textChanged(action: @escaping (String) -> Void) {
        self.callbacktxtviewsubcomment = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        callbacktxtviewsubcomment?(textView.text)
    }
    
    @IBAction func buttonTappedReply(_ sender:UIButton){
        self.callBack?("reply")
    }
    
    @IBAction func buttonTappedPost(_ sender:UIButton){
        self.callBack?("post")
    }
    
    @IBAction func buttonTappedCancel(_ sender:UIButton){
        self.callBack?("cancel")
    }
}
