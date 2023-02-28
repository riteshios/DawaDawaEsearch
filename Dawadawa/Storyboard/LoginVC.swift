//  LoginVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 11/06/22.

import UIKit
import SKFloatingTextField
import GoogleSignIn

class LoginVC: UIViewController {
    
    //     MARK: - Properties -
    
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
    @IBOutlet weak var lblThirdOR: UILabel!
    
    @IBOutlet weak var viewDrop: UIView!
    @IBOutlet weak var btndrop: UIButton!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var lblArabic: UILabel!
    @IBOutlet weak var btnArabic: UIButton!
    @IBOutlet weak var lblDropDownMenu: UILabel!
    @IBOutlet weak var imgDropDownMenu: UIImageView!
    
    var payment_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
        txtFieldPassword.isSecureTextInput = true
    }
    
    
    override func viewWillLayoutSubviews() {
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            DispatchQueue.main.async {
                self.txtFieldPhoneNumer.semanticContentAttribute = .forceLeftToRight
                self.txtFieldPhoneNumer.textAlignment = .left
                self.txtFieldPassword.semanticContentAttribute = .forceLeftToRight
                self.txtFieldPassword.textAlignment = .left
            }
            
        } else {
            DispatchQueue.main.async {
                self.txtFieldPhoneNumer.semanticContentAttribute = .forceRightToLeft
                self.txtFieldPhoneNumer.textAlignment = .right
                self.txtFieldPassword.semanticContentAttribute = .forceRightToLeft
                self.txtFieldPassword.textAlignment = .right
            }
        }
    }
    
    //    MARK: - LIfe Cycle and Methods -
    
    func setup(){
        //        self.txtFieldPhoneNumer.keyBoardType = .numberPad
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewButtonLogin.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldPassword, place: "Password", floatingText: "Password")
      
        self.setTextFieldUI(textField: txtFieldPhoneNumer, place: "Phone number/Email", floatingText: "Phone number/Email")
        self.viewDrop.isHidden = true
        self.viewDrop.addShadowWithCornerRadius(viewDrop, cRadius: 5)
        
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            self.imgDropDownMenu.image = UIImage(named: "IND")
            self.lblDropDownMenu.text = "English-IND"
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else{
            self.imgDropDownMenu.image = UIImage(named: "sudan")
            self.lblDropDownMenu.text = "عربي"
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
        }

    }
    //  MARK: - @IBAction -
    
    @IBAction func btnDropTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.viewDrop.isHidden = false
        }
        else{
            self.viewDrop.isHidden = true
        }
    }
    
    @IBAction func btnEnglishLangTapped(_ sender: UIButton){
        self.setupUpdateView(languageCode: "en")
        kSharedUserDefaults.setLanguage(language: "en")
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnArabicLangTapped(_ sender: UIButton){
        self.setupUpdateView(languageCode: "ar")
        kSharedUserDefaults.setLanguage(language: "ar")
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "636451100488-1k8eq045hd097ar24g78743ll5ufhhsn.apps.googleusercontent.com")
        
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
                //   self.googleloginApi(accountName: givenName, email: email, googleId: userId)
            }
        }
    }
    
    @IBAction func btnSecurePasswordTaspped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFieldPassword.isSecureTextInput.toggle()
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
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
        self.loginapi()
    }
    
    @IBAction func btnSkipLoginTapped(_ sender: UIButton) {
        UserData.shared.isskiplogin = true
        cameFrom = ""
        kSharedAppDelegate?.makeRootViewController()
    }
    
    // MARK: -validation
    
    func validation(){
        if String.getString(self.txtFieldPhoneNumer.text).isEmpty
        {
            self.showSimpleAlert(message: Notifications.kentermobileemail)
            return
        }
        else if !String.getString(self.txtFieldPhoneNumer.text).isphoneandemail()
        {
            self.showSimpleAlert(message: Notifications.kentervalidphoneemail)
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
//        self.loginapi()
    }
    //    func validation(){
    //        if String.getString(self.txtFieldPhoneNumer.text).isEmpty
    //        {
    //            self.showSimpleAlert(message: Notifications.kEnterMobileNumber)
    //            return
    //        }
    //        else if !String.getString(self.txtFieldPhoneNumer.text).isPhoneNumber()
    //        {
    //            self.showSimpleAlert(message: Notifications.kEnterValidMobileNumber)
    //            return
    //        }
   
    //        else if String.getString(self.txtFieldPassword.text).isEmpty
    //        {
    //            showSimpleAlert(message: Notifications.kPassword)
    //            return
    //        }
    //        else if !String.getString(txtFieldPassword.text).isValidPassword()
    //        {
    //            self.showSimpleAlert(message: Notifications.kValidPassword)
    //            return
    //        }
    //        self.view.endEditing(true)
    //        self.loginapi()
    //    }
}

// MARK: - SKFloating -
extension LoginVC{

    func setTextFieldUI(textField:SKFloatingTextField,place:String ,floatingText:String){

        textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        //floatingTextField.setRectTFUI()
        //floatingTextField.setRoundTFUI()
        //floatingTextField.setOnlyBottomBorderTFUI()
//                textField.setCircularTFUI()
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
// MARK: - Api Call -

// Login Api
extension LoginVC{
    func loginapi(){
        CommonUtils.showHud(show: true)
        
        let params:[String : Any] = [
            "phone":String.getString(self.txtFieldPhoneNumer.text),
            "password":String.getString(self.txtFieldPassword.text),
            "device_type":"1",
            "device_id":kSharedUserDefaults.getDeviceToken()
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
                        cameFrom = ""
                        
                        kSharedUserDefaults.setpayment_type(paymenttype: String.getString(dictResult[kpayment_type]))
                        
                        
                        if Int.getInt(UserData.shared.check_sub_plan) == 1{
                            kSharedAppDelegate?.makeRootViewController()
                           
                        }
                        else if Int.getInt(UserData.shared.check_sub_plan) == 0{

                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginSubscriptionPlanVC") as! LoginSubscriptionPlanVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                
                        }
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
//                CommonUtils.showToastForDefaultError()
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
            //          headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        
        let params:[String:Any] = ["username":accountName,
                                   "email":email,
                                   "g_id":googleId,
                                   "device_type":"1",
                                   "device_id":kSharedUserDefaults.getDeviceToken()
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kgooglelogin, requestMethod: .POST, requestParameters: params, withProgressHUD: false) { (result:Any?,error: Error?, errorType:ErrorType, statussCode:Int?) in
            if errorType == .requestSuccess{
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statussCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(dictResult[kLoggedInAccessToken]))
                        UserData.shared.saveData(data: data, token:  String.getString(dictResult[kLoggedInAccessToken]))
                        //                            UserData.shared.saveData(data: data, token: "")
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
//                CommonUtils.showToastForDefaultError()
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
        lblDontHaveAccount.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Don't have an account?", comment: "")
//        lblFirstOR.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        lblSecondOR.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        lblThirdOR.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        btnCreateAccount.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Create account", comment: ""), for: .normal)
        btnForgotPassword.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Forgot Password", comment: ""), for: .normal)
        btnSkipLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Skip login", comment: ""), for: .normal)
        btnLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: ""), for: .normal)
        
        txtFieldPhoneNumer.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number/Email*", comment: "")
        txtFieldPhoneNumer.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number/Email*", comment: "")
        txtFieldPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")
        txtFieldPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")

    }
    
    func setupUpdateView(languageCode code: String){
        LocalizationSystem.sharedInstance.setLanguage(languageCode: code)
        UIView.appearance().semanticContentAttribute =  code == "ar" ? .forceRightToLeft :  .forceLeftToRight
    }
}
