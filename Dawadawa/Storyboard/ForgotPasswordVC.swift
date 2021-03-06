//
//  ForgotPasswordVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 12/06/22.
//

import UIKit
import SKFloatingTextField

class ForgotPasswordVC: UIViewController {
    
//    MARK: - Properties
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewButtonSendCode: UIView!
    @IBOutlet weak var btnSendEmail_Phone: UIButton!
    @IBOutlet weak var lblSendEmail_Phone: UILabel!
    
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var btnSendCode: UIButton!
    
    @IBOutlet weak var txtFieldPhone_Email: SKFloatingTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setup()
       
    }
// MARK: - Life Cyclye
    func setup(){
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewButtonSendCode.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Phone number", floatingText: "Phone number")
        txtFieldPhone_Email.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
        txtFieldPhone_Email.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
        self.lblSendEmail_Phone.text = "Send on email address"
        lblSendEmail_Phone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on email address", comment: "")
    }
    
// MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendEmail_PhoneTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSendEmail_Phone.isSelected == true{
            self.lblSendEmail_Phone.text = "Send on phone number"
            lblSendEmail_Phone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on phone number", comment: "")
            self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Email address", floatingText: "Email address")
            txtFieldPhone_Email.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email address", comment: "")
            txtFieldPhone_Email.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email address", comment: "")
           
        }
        else{
            self.setTextFieldUI(textField: txtFieldPhone_Email, place: "Phone number", floatingText: "Phone number")
            self.lblSendEmail_Phone.text = "Send on email address"
            lblSendEmail_Phone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on email address", comment: "")
            txtFieldPhone_Email.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
            txtFieldPhone_Email.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
           
        }
    }
    
    
    @IBAction func btnsendCodeTapped(_ sender: UIButton) {
      
//        if (self.lblSendEmail_Phone.text == "Send on email address")
//           {
//            self.lblSendEmail_Phone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on email address", comment: "")
//            self.fieldvalidationPhoneNumber()
//        }
//
//        else if (self.lblSendEmail_Phone.text == "Send on phone number")
//
//        {
//            lblSendEmail_Phone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on phone number", comment: "")
//            self.fieldvalidationEmailAdress()
//        }
        
        if self.lblSendEmail_Phone.text == LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on email address", comment: "")
        {
            self.fieldvalidationPhoneNumber()
        }
       
        else if  lblSendEmail_Phone.text == LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send on phone number", comment: "")
                    
        {
            self.fieldvalidationEmailAdress()
        }
       
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
        self.view.endEditing(true)
        self.forgotpasswordapi()
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

extension ForgotPasswordVC{
    func forgotpasswordapi(){
        
        CommonUtils.showHud(show: true)
        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
       

        let params:[String : Any] = [
            "email":String.getString(self.txtFieldPhone_Email.text),
        ]

        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kforgotpassword, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
               
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: ActivationCodeVC.getStoryboardID()) as! ActivationCodeVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.type = .forgotPass
                        vc.email = String.getString(self?.txtFieldPhone_Email.text)
                        vc.callback =
                        {
                            vc.dismiss(animated: false){
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: ResetPasswordVC.getStoryboardID()) as! ResetPasswordVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.email = String.getString(self?.txtFieldPhone_Email.text)
                                vc.callback2 = {
                                    self?.dismiss(animated: false) {
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ActivatedSuccessfullyPopUpVC") as! ActivatedSuccessfullyPopUpVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overCurrentContext
                                        vc.type = .reset
                                        vc.callback1 = {
                                            self?.dismiss(animated: true){
                                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                                self?.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }
                                        self?.present(vc, animated: false)
                                    }
                                }
                                self?.present(vc, animated: false)
                            }
                        }
                        self?.present(vc, animated: false)
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
}


extension ForgotPasswordVC{
    func setuplanguage(){
        btnSendCode.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send code", comment: ""), for: .normal)
        lblForgotPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Forgot Password", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Provide your registered email address or phone number to reset your password ", comment: "")
    }
}
