//
//  ResetPasswordVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 12/06/22.
//

import UIKit
import SKFloatingTextField

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ViewButtonResetPassword: UIView!
    
    @IBOutlet weak var txtFieldNewPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    var callback2:(()->())?
    var email:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.ViewButtonResetPassword.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldNewPassword, place: "New password", floatingText: "New password")
        self.setTextFieldUI(textField: txtFieldConfirmPassword, place: "Confirm password ", floatingText: "Confirm password ")
    }
    
    @IBAction func btnResetPasswordTapped(_ sender: UIButton) {
        self.fieldValidations()
    }
    func fieldValidations(){
    if String.getString(self.txtFieldNewPassword.text).isEmpty{
        self.showSimpleAlert(message: Notifications.kNewPassword)
        return
    }else if !String.getString(self.txtFieldNewPassword.text).isPasswordValidate(){
        self.showSimpleAlert(message: Notifications.kValidPassword)
        return
    }else if String.getString(txtFieldConfirmPassword.text).isEmpty {
        self.showSimpleAlert(message: Notifications.kConfirmpassword)
        return
}else if(txtFieldNewPassword.text != self.txtFieldConfirmPassword.text){
    self.showSimpleAlert(message: Notifications.kconfirmMismatch)
    return
}
        self.view.endEditing(true)
        self.resetpasswordapi()
//        self.callback2?()
    }

}
extension ResetPasswordVC{
    
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
extension ResetPasswordVC : SKFlaotingTextFieldDelegate {

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

extension ResetPasswordVC{
    func resetpasswordapi(){
        
        CommonUtils.showHud(show: true)
        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
        let params:[String : Any] = [
            "email":self.email,
            "password":String.getString(self.txtFieldNewPassword.text),
            "password_confirmation":String.getString(self.txtFieldConfirmPassword.text)
        ]

        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kresetpassword, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                            self?.callback2?()
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if Int.getInt(dictResult["status"]) == 403{
                        let response = kSharedInstance.getDictionary(dictResult["response"])
                        let msg = kSharedInstance.getStringArray(response["otp"])
                        CommonUtils.showError(.info, msg[0])// msg is on 0th index
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
