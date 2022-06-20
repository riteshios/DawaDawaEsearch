//
//  ForgotPasswordVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 12/06/22.
//

import UIKit
import SKFloatingTextField

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var viewButtonSendCode: UIView!
    @IBOutlet weak var btnSendEmail_Phone: UIButton!
    @IBOutlet weak var lblSendEmail_Phone: UILabel!
    
    @IBOutlet weak var txtFieldPhone_Email: SKFloatingTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewButtonSendCode.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Phone number", floatingText: "Phone number")
        self.lblSendEmail_Phone.text = "Send on email address"
    }
    
    @IBAction func btnSendEmail_PhoneTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSendEmail_Phone.isSelected == true{
            self.lblSendEmail_Phone.text = "Send on phone number"
            self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Email address", floatingText: "Email address")
           
        }
        else{
            self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Phone number", floatingText: "Phone number")
            self.lblSendEmail_Phone.text = "Send on email address"
           
        }
    }
    
    
    @IBAction func btnsendCodeTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ActivationCodeVC.getStoryboardID()) as! ActivationCodeVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.type = .forgotPass
        if (self.lblSendEmail_Phone.text == "Send on email address"){
            self.fieldvalidationPhoneNumber()
        }
        else if (self.lblSendEmail_Phone.text == "Send on phone number"){
            self.fieldvalidationEmailAdress()
        }
        vc.callback =
        {
            vc.dismiss(animated: false){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ResetPasswordVC.getStoryboardID()) as! ResetPasswordVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callback2 = {
                    self.dismiss(animated: false) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivatedSuccessfullyPopUpVC") as! ActivatedSuccessfullyPopUpVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.type = .reset
                        vc.callback1 = {
                            self.dismiss(animated: true){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        self.present(vc, animated: false)
                    }
                }
                self.present(vc, animated: false)
            }
        }
        self.present(vc, animated: false)
    }
    
    
//  MARK: - Validation
    func fieldvalidationPhoneNumber(){
        if String.getString(self.txtFieldPhone_Email.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterMobileNumber)
            return
        }
        else if !String.getString(txtFieldPhone_Email.text).isPhoneNumber()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidMobileNumber)
            return
        }
    }
    func fieldvalidationEmailAdress(){
        if String.getString(self.txtFieldPhone_Email.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterEmail)
            return
        }
        else if !String.getString(txtFieldPhone_Email.text).isEmail()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidEmail)
            return
        }
    }
}



extension ForgotPasswordVC{
    
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
extension ForgotPasswordVC : SKFlaotingTextFieldDelegate {
    
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

