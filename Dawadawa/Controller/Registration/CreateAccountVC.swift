//
//  CreateAccountVC.swift
//  Dawadawa
//

//  Created by Alekh Verma on 09/06/22.
//

import UIKit
import SKFloatingTextField
import WebKit
import GoogleSignIn


class CreateAccountVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var viewMain: UIView!
   
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var viewCreateAccountButton: UIView!
    @IBOutlet weak var btnCountrySelect: UIButton!
    
    @IBOutlet weak var lblCreateAccount: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var lblPleaseAccept: UILabel!
    @IBOutlet weak var lbland: UILabel!
    @IBOutlet weak var lblAlready: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblor: UILabel!
    @IBOutlet weak var lblIndicate: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var txtFieldFirstName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLastName: SKFloatingTextField!
    @IBOutlet weak var txtFieldEmail: SKFloatingTextField!
    @IBOutlet weak var txtFieldPhoneNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var btnTermAndCondition: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnTandC: UIButton!
    @IBOutlet weak var btnDropUserType: UIButton!
    
    let webview = WKWebView()
    var isCountry = false
    var isprivacypolicy = false
    var google_id = ""
    var socialprofile = ""
    var usertype = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setuplanguage()
        
    }
    
    
    
    func setup(){
        
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewCreateAccountButton.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        self.setTextFieldUI(textField: txtFieldFirstName, place: "First name*", floatingText: "First name")
        self.setTextFieldUI(textField: txtFieldLastName, place: "Last name*", floatingText: "Last name")
        self.setTextFieldUI(textField: txtFieldEmail, place: "Email address*", floatingText: "Email address")
        self.setTextFieldUI(textField: txtFieldPhoneNumber, place: "Phone number* ", floatingText: "Phone number")
        self.setTextFieldUI(textField: txtFieldPassword, place: "Password*", floatingText: "Password")
        self.setTextFieldUI(textField: txtFieldConfirmPassword, place: "Confirm password*", floatingText: "Confirm password")
        self.txtFieldPassword.delegate = self
        self.txtFieldConfirmPassword.delegate = self
        self.viewCountry.isHidden = true
        
        self.txtFieldPhoneNumber.keyBoardType = .numberPad
    }
    //   MARK: - @IBACtions
    
    
    @IBAction func btnTerms(_ sender: UIButton) {
        self.termsandConditionApi()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewVC.getStoryboardID()) as! WebViewVC
//        vc.strurl = "https://demo4app.com/dawadawa/api-terms?lang=en"
//        vc.head = "Terms and Condition"
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func btnprivacy(_ sender: UIButton) {
        self.PrivacypolicyApi()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewVC.getStoryboardID()) as! WebViewVC
//        vc.strurl = "https://demo4app.com/dawadawa/api-privacy-policy"
//        vc.head = "Privacy Policy"
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnGoogleLoginTapped(_ sender: UIButton) {
        //        self.googleSignin()
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
                
            }
        }
    }
    
    @IBAction func btnCountrySelecTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnCountrySelect.isSelected == true{
            self.viewCountry.isHidden = false
        }
        AppsCountryPickerInstanse.sharedInstanse.showController(referense: self) { (selectedCountry) in
            
            self.labelCountry.text = selectedCountry?.name
            self.imageFlag.image = selectedCountry?.image ?? UIImage()
            self.isCountry = true
        }
    }
    
    @IBAction func btnTermsAndCondition(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isprivacypolicy = true
    }
    
    @IBAction func btnDropSelectUserType(_ sender: UIButton){
        let dataSource1 = ["Investor","Business Owner","Service Provider"]
        kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropUserType)
        {(Index ,item) in
            self.lblUserType.text = item
            self.usertype = Index
            debugPrint("usertpe=-=-=",self.usertype)

        }
    }
    
    @IBAction func btnSecurePasswordTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtFieldPassword.isSecureTextInput.toggle()
    }
    @IBAction func btnSecureConfirmPasswordTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        txtFieldConfirmPassword.isSecureTextInput.toggle()
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: UIButton){
        self.Validation()
    }
    @IBAction func btnSkipRegistration(_ sender: UIButton) {
        UserData.shared.isskiplogin = true
        kSharedAppDelegate?.makeRootViewController()
    }
    
    
    
    // MARK: - Validation
    
    func Validation()
    {
        if String.getString(self.txtFieldFirstName.text).isEmpty
        {
            self.showSimpleAlert(message: Notifications.kFirstName)
            return
        }
        else if !String.getString(self.txtFieldFirstName.text).isValidUserName()
        {
            self.showSimpleAlert(message: Notifications.kvalidfirsname)
            return
        }
        
        else if String.getString(self.txtFieldLastName.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kLastName)
            return
        }
        else if !String.getString(txtFieldLastName.text).isValidUserName()
        {
            self.showSimpleAlert(message: Notifications.kvalidlastname)
            return
        }
        //        else if self.isCountry == false{
        //            self.showSimpleAlert(message: "Please Select the Country")
        //        }
        
        else if String.getString(self.txtFieldEmail.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterEmail)
            return
        }
        else if !String.getString(txtFieldEmail.text).isEmail()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidEmail)
            return
        }
        
        else if String.getString(self.txtFieldPhoneNumber.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterMobileNumber)
            return
        }
        else if !String.getString(txtFieldPhoneNumber.text).isPhoneNumber()
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
        else if String.getString(txtFieldConfirmPassword.text).isEmpty {
            self.showSimpleAlert(message: Notifications.kConfirmPassword)
            return
        }
        else if(txtFieldPassword.text != self.txtFieldConfirmPassword.text)
        {
            self.showSimpleAlert(message: Notifications.kMatchPassword)
            return
        }
        else if self.isprivacypolicy == false{
            self.showSimpleAlert(message: "Please Select T&C and Privacy Policy")
        }
        self.view.endEditing(true)
        self.createAccountapi()
    }
    //    social login
    //    func googleSignin(){
    //        let signInConfig = GIDConfiguration.init(clientID: "290314984120-fidp05vtumuat8sn6mcpc0pofrunrjs5.apps.googleusercontent.com")
    //        GIDSignIn.sharedInstance.signOut()
    //        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
    //
    //
    //            guard error == nil else { return }
    //            guard let user = user else { return }
    //
    //            let emailAddress = user.profile?.email
    //
    //            let fullName = user.profile?.name
    //            let givenName = user.profile?.givenName
    //            let familyName = user.profile?.familyName
    //            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
    //            let userID      =  user.userID
    //            print("Email: \(emailAddress), Name: \(fullName), GiveName: \(givenName), FamilyName: \(familyName), PIC: \(profilePicUrl), ID: \(userID)")
    //
    //            var firstName = String.getString(fullName)
    //            var lastName = String.getString(familyName)
    //            self.id = String.getString(userID)
    //            //            self.socialData.googleImage = profilePicUrl
    //            self.socialType = "1"
    //            self.emailId = String.getString(emailAddress)
    //
    //            //            user.authentication.do { authentication, error in
    //            //                    guard error == nil else { return }
    //            //                    guard let authentication = authentication else { return }
    //            //
    //            //                    let idToken = authentication.idToken
    //            //                    // Send ID token to backend (example below).
    //            //                print("Token :", idToken)
    //            //
    //            //
    //            //                }
    //            self.googleSigninApi()
    //
    //        }
    //    }
}

extension CreateAccountVC{
    
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
extension CreateAccountVC : SKFlaotingTextFieldDelegate {
    
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

//    MARK: - API

// Create Account
extension CreateAccountVC {
    func createAccountapi(){
        
        CommonUtils.showHud(show: true)
        let params: [String:Any] = [
            "firstname":String.getString(self.txtFieldFirstName.text),
            "lastname":String.getString(self.txtFieldLastName.text),
            "email":String.getString(self.txtFieldEmail.text),
            "user_country":self.labelCountry.text,
            "phone":String.getString(self.txtFieldPhoneNumber.text),
            "device_type":"1",
            "device_id":"REFw2321",
            "password":String.getString(self.txtFieldPassword.text),
            "confirm_password":String.getString(self.txtFieldConfirmPassword.text),
            "user_type":Int.getInt(self.usertype)
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kcreateAccount, requestMethod: .POST, requestParameters: params, withProgressHUD: false) { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode){
                case 200:
                    //                    UserData.shared.saveData (data:dictResult)
                    //                    self.save()
                    //                    UserDefaults.standard.set(String.getString(self.txtFieldEmail.text), forKey: "email")
                    if Int.getInt(dictResult["status"]) == 200{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ActivationCodeVC.getStoryboardID()) as! ActivationCodeVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.type = .signUp
                        vc.email = String.getString(self.txtFieldEmail.text)
                        vc.callback =
                        {
                            vc.dismiss(animated: false){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ActivatedSuccessfullyPopUpVC.getStoryboardID()) as! ActivatedSuccessfullyPopUpVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.type = .signUp
                                vc.callback1 = {
                                    self.dismiss(animated: false) {
                                        
                                        kSharedAppDelegate?.moveToLoginScreen()
                                        //                                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                                        //                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                                self.present(vc, animated: false)
                            }
                        }
                        self.present(vc, animated: false)
                    }
                    if Int.getInt(dictResult["status"]) == 400{
                        let response = kSharedInstance.getDictionary(dictResult["response"])
                        
                        if let _ = response["email"] {
                            let msg = kSharedInstance.getStringArray(response["email"])
                            CommonUtils.showError(.info, msg[0])// msg is on 0th index
                        }
                        else if let _ = response["phone"] {
                            let msg = kSharedInstance.getStringArray(response["phone"])
                            CommonUtils.showError(.info, msg[0])// msg is on 0th index
                        }
                        //let msg = kSharedInstance.getStringArray(response["phone"])
                        // CommonUtils.showError(.info, msg[0])// msg is on 0th index
                        
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
                        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(dictResult[kLoggedInAccessToken]))
                        UserData.shared.saveData(data: data, token:  String.getString(dictResult[kLoggedInAccessToken]))
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
    
    // terms and Condition api
    
    func termsandConditionApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.ktermsandcondition, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
            
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewVC.getStoryboardID()) as! WebViewVC
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
        
    }
    
//    Privacy policy api
    
    func PrivacypolicyApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kprivacypolicy, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
            
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewVC.getStoryboardID()) as! WebViewVC
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
}

extension CreateAccountVC{
    func setuplanguage(){
        lblCreateAccount.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Create account", comment: "")
        lblGoogle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google", comment: "")
        lblFacebook.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Facebook", comment: "")
        lblTwitter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Twitter", comment: "")
        lblAlready.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Already have an account?", comment: "")
        lblPleaseAccept.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please accept our", comment: "")
        lbland.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "and", comment: "")
        lblOr.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        lblor.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "or", comment: "")
        lblIndicate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "(*) indicates mandatory fields *", comment: "")
        btnPrivacyPolicy.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Privacy Policy", comment: ""), for: .normal)
        btnSkip.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Skip registration", comment: ""), for: .normal)
        btnLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: ""), for: .normal)
        btnCreateAccount.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Create account", comment: ""), for: .normal)
        btnTandC.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "T&C", comment: ""), for: .normal)
        txtFieldFirstName.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "First name", comment: "")
        txtFieldFirstName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "First name", comment: "")
        txtFieldLastName.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last name", comment: "")
        txtFieldLastName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last name", comment: "")
        txtFieldEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email address*", comment: "")
        txtFieldEmail.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email address*", comment: "")
        txtFieldPhoneNumber.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number*", comment: "")
        txtFieldPhoneNumber.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number*", comment: "")
        txtFieldPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")
        txtFieldPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password", comment: "")
        txtFieldConfirmPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password", comment: "")
        txtFieldConfirmPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password", comment: "")
        
    }
}

