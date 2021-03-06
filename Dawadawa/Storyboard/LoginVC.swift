//
//  LoginVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/06/22.
//

import UIKit
import SKFloatingTextField
import GoogleSignIn

class LoginVC: UIViewController {
    
//     MARK: - Properties
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewButtonLogin: UIView!
    @IBOutlet weak var txtFieldPhoneNumer: SKFloatingTextField!
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblTwitter: UILabel!
    
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSkipLogin: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblFirstOR: UILabel!
    @IBOutlet weak var lblSecondOR: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
        
    }
    
    
//    MARK: - LIfe Cyclye
    

    
    
    func setup(){
        self.txtFieldPhoneNumer.keyBoardType = .numberPad
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewButtonLogin.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldPhoneNumer, place: "Phone number", floatingText: "Phone number")
        self.setTextFieldUI(textField: txtFieldPassword, place: "Password", floatingText: "Password")
    }
    //  MARK: - @IBAction
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "330854842489-c25b86f35mmp4ckogq99l06tn52jj4ki.apps.googleusercontent.com")
        
        
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            
            guard error == nil else { return }
            
            guard let user = user else { return }
            
            
            
            if let profiledata = user.profile {
                
                
                
                let userId : String = user.userID ?? ""
                
                let username : String = profiledata.givenName ?? ""
                
                let email : String = profiledata.email
                
                
                
                if let imgurl = user.profile?.imageURL(withDimension: 100) {
                    
                    let absoluteurl : String = imgurl.absoluteString
                    
                    //HERE CALL YOUR SERVER APP
                }
                self.googleSigninApi(accountName: username, email: email, googleId: userId)
                //                           self.googleloginApi(accountName: givenName, email: email, googleId: userId)
                
            }
        }
    }
    
    @IBAction func btnSecurePasswordTaspped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFieldPassword.isSecureTextInput.toggle()
    }
    
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
    @IBAction func btnSkipLoginTapped(_ sender: UIButton) {
        UserData.shared.isskiplogin = true
        kSharedAppDelegate?.makeRootViewController()
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
// MARK: - Api Call

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
                        UserData.shared.isskiplogin = false
                       
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
    //    GoogleLoginApi
        func googleSigninApi(accountName: String, email: String, googleId: String){
            CommonUtils.showHudWithNoInteraction(show: true)
            
            if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
                let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                let septoken = endToken.components(separatedBy: " ")
                if septoken[0] != "Bearer"{
                    let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
                }
                //            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
            }
            
            let params:[String:Any] = ["username":accountName,
                                       "email":email,
                                       "g_id":googleId,
                                       "device_type":"IOS",
                                       "device_id":"1212",
            ]
            
            TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kgooglelogin, requestMethod: .POST, requestParameters: params, withProgressHUD: false) { (result:Any?,error: Error?, errorType:ErrorType, statussCode:Int?) in
                if errorType == .requestSuccess{
                    let dictResult = kSharedInstance.getDictionary(result)
                    switch Int.getInt(statussCode) {
                    case 200:
                        if Int.getInt(dictResult["status"]) == 200{
                            let data = kSharedInstance.getDictionary(dictResult["data"])
                            kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)

                            UserData.shared.saveData(data: data, token: "")
                            kSharedAppDelegate?.makeRootViewController()
                        }
                        else if  Int.getInt(dictResult["status"]) == 400{
                            CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        }
                    default:
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                }else if errorType == .noNetwork {
                    CommonUtils.showToastForInternetUnavailable()
                    
                } else {
                    CommonUtils.showToastForDefaultError()
                }
            }
        }

    }
extension LoginVC{
    
    func setuplanguage(){
        lblLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: "")
        lblGoogle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google", comment: "")
        lblFacebook.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Facebook", comment: "")
        lblTwitter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Twitter", comment: "")
        lblDontHaveAccount.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Don't have Account", comment: "")
        lblFirstOR.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        lblSecondOR.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        btnCreateAccount.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Create account", comment: ""), for: .normal)
        btnForgotPassword.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Forgot Password", comment: ""), for: .normal)
        btnSkipLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Skip login", comment: ""), for: .normal)
        btnLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: ""), for: .normal)
        txtFieldPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")
        txtFieldPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")
        txtFieldPhoneNumer.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
        txtFieldPhoneNumer.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
        
    }
}


