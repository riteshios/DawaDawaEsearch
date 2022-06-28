//
//  ChangePasswordVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit
import SKFloatingTextField

class ChangePasswordVC: UIViewController {
    
    var callbackchangepassword:(()->())?
    
    @IBOutlet weak var txtFieldNewPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    @IBOutlet weak var viewBtnChangePassword: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFieldUI(textField: txtFieldNewPassword, place: "New password", floatingText: "New password")
        self.setTextFieldUI(textField: txtFieldConfirmPassword, place: "Confirm password", floatingText: "Confirm password")
        self.viewBtnChangePassword.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    @IBAction func btnChangePasswordTapped(_ sender: UIButton) {
        self.callbackchangepassword?()
    }
    
   

}
extension ChangePasswordVC{
    
    func setTextFieldUI(textField:SKFloatingTextField,place:String ,floatingText:String){
        
        textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        //floatingTextField.setRectTFUI()
        //floatingTextField.setRoundTFUI()
        //floatingTextField.setOnlyBottomBorderTFUI()
        //        textField.setCircularTFUI()
        textField.setRoundTFUI()
        textField.delegate = self
        //floatingTextField.errorLabelText = "Error"
        
    }
}
extension ChangePasswordVC : SKFlaotingTextFieldDelegate {
    
    func textFieldDidEndEditing(textField: SKFloatingTextField) {
        print("end editing")
    }
    
    func textFieldDidChangeSelection(textField: SKFloatingTextField) {
        print("changing text")
    }
    
    func textFieldDidBeginEditing(textField: SKFloatingTextField) {
        print("begin editing")
    }
}
