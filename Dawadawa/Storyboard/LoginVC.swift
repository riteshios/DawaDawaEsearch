//
//  LoginVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/06/22.
//

import UIKit
import SKFloatingTextField

class LoginVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewButtonLogin: UIView!
    
    @IBOutlet weak var txtFieldPhoneNumer: SKFloatingTextField!
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewButtonLogin.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldPhoneNumer, place: "Phone number", floatingText: "Phone number")
        self.setTextFieldUI(textField: txtFieldPassword, place: "Password", floatingText: "Password")
    }
    //  MARK: - @IBAction
    @IBAction func btnCreateAccountTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //    @IBAction func btnSecurePassword(_ sender: UIButton){
    //        sender.isSelected = !sender.isSelected
    //        txtFieldPassword.isSecureTextEntry.toggle()
    //    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton){
        self.validation()
    }
    
    // MARK: -validation
    func validation(){
        if String.getString(self.txtFieldPhoneNumer.text).isEmpty
        {
            self.showSimpleAlert(message: Notifications.kEnterMobileNumber)
            return
        }
        else if !String.getString(self.txtFieldPhoneNumer.text).isPhoneNumber()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidMobileNumber)
            return
        }
        
        else if String.getString(self.txtFieldPassword.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kPassword)
            return
        }
        else if !String.getString(txtFieldPassword.text).isValidPassword()
        {
            self.showSimpleAlert(message: Notifications.kValidPassword)
            return
        }
        self.view.endEditing(true)
        self.loginapi()
    }
}
extension LoginVC{
    
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
extension LoginVC : SKFlaotingTextFieldDelegate {
    
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
// MARK: Api

extension LoginVC{
    func loginapi(){
        
        CommonUtils.showHud(show: true)
        
        let params:[String : Any] = [
            "phone":String.getString(self.txtFieldPhoneNumer.text),
            "password":String.getString(self.txtFieldPassword.text)
        ]

        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.klogin, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                   
                    if Int.getInt(dictResult["status"]) == 200{
                       
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(dictResult[kLoggedInAccessToken]))
                        UserData.shared.saveData(data: data, token: String.getString(dictResult[kLoggedInAccessToken]))

//                        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "Bearer \(String.getString(dictResult["token"]))")
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        kSharedAppDelegate?.makeRootViewController()
                        
                        
//                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//                        vc.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        CommonUtils.showError(.info, "Password incorrect")
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
