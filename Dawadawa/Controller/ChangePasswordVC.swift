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
//        self.callbackchangepassword?()
        self.changepasswordapi()
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
extension ChangePasswordVC{
    func changepasswordapi(){
        
        CommonUtils.showHud(show: true)
        
       
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
//            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }

        let params:[String : Any] = [
            "user_id":UserData.shared.id,
            "new_password":String.getString(self.txtFieldNewPassword.text),
            "confirm_password":String.getString(self.txtFieldConfirmPassword.text)
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


