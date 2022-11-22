//
//  ChangePasswordVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/06/22.


import UIKit
import SKFloatingTextField

class ChangePasswordVC: UIViewController {
    
    var callbackchangepassword:(()->())?
    
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblEnternew: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var txtFieldNewPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    @IBOutlet weak var viewBtnChangePassword: UIView!
    
    //     MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFieldUI(textField: txtFieldNewPassword, place: "New password", floatingText: "New password")
        self.setTextFieldUI(textField: txtFieldConfirmPassword, place: "Confirm password", floatingText: "Confirm password")
        self.viewBtnChangePassword.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    @IBAction func btnChangePasswordTapped(_ sender: UIButton) {
        //        self.callbackchangepassword?()
        self.fieldValidations()
    }
    
    //   MARK: - Validation
    
    func fieldValidations(){
        if String.getString(self.txtFieldNewPassword.text).isEmpty{
            self.showSimpleAlert(message: "Please Enter New Password")
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
        self.changepasswordapi()
        //        self.callback2?()
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

// MARK: - API call

extension ChangePasswordVC{
    
    func changepasswordapi(){
        
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
            //            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        
        let params:[String : Any] = [
            "id":UserData.shared.id,
            "new_password":String.getString(self.txtFieldNewPassword.text),
            "confirm_password":String.getString(self.txtFieldConfirmPassword.text)
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kchangepassword, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        self?.callbackchangepassword?()
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



                      
                        
extension ChangePasswordVC{
    func setuplanguage(){
        lblChangePassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change Password", comment: "")
        lblEnternew.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter new password for your account", comment: "")
        txtFieldNewPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "New password", comment: "")
        txtFieldNewPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "New password", comment: "")
        txtFieldConfirmPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password", comment: "")
        txtFieldConfirmPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password", comment: "")
        btnChangePassword.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change Password", comment: ""), for: .normal)
        }
    }
