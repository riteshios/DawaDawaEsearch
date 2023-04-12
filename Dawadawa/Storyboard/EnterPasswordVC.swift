//  EnterPasswordVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/12/22.

import UIKit
import SKFloatingTextField

class EnterPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblCheckEightChar: UILabel!
    @IBOutlet weak var lblCheckupperandlowerChar: UILabel!
    @IBOutlet weak var lblCheckNumberChar: UILabel!
    @IBOutlet weak var lblCheckSpecialChar: UILabel!
    @IBOutlet weak var lblPlsAccept: UILabel!
    @IBOutlet weak var lbland: UILabel!
    
//    @IBOutlet weak var btnTandC: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
   
    @IBOutlet weak var imgCheckSixChar: UIImageView!
    @IBOutlet weak var imgCheckupperandlowerChar: UIImageView!
    @IBOutlet weak var imgCheckNumberChar: UIImageView!
    @IBOutlet weak var imgCheckSpecialChar: UIImageView!
    @IBOutlet weak var btnTandC: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    
    var name = ""
    var lastame = ""
    var usertype = 0
    var email = ""
    var phone = ""
    var country = ""
    var state = ""
    var locality = ""
    
    var checkPass = ""
    var isprivacypolicy = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.txtFieldPassword.delegate = self
        self.txtFieldConfirmPassword.delegate = self
        self.setup()
        self.setuplanguage()
    }
    
    override func viewWillLayoutSubviews() {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                DispatchQueue.main.async {
                    self.txtFieldPassword.semanticContentAttribute = .forceLeftToRight
                    self.txtFieldPassword.textAlignment = .left
                    self.txtFieldConfirmPassword.semanticContentAttribute = .forceLeftToRight
                    self.txtFieldPassword.textAlignment = .left
                }

            } else {
                DispatchQueue.main.async {
                    self.txtFieldPassword.semanticContentAttribute = .forceRightToLeft
                    self.txtFieldPassword.textAlignment = .right
                    self.txtFieldConfirmPassword.semanticContentAttribute = .forceRightToLeft
                    self.txtFieldConfirmPassword.textAlignment = .right
                }
            }
        }
//    MARK: - Life Cycle
    
    func setup(){
        
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.txtFieldPassword.delegate = self
        self.txtFieldConfirmPassword.delegate = self
        self.setTextFieldUI(textField: txtFieldPassword, place: "Password*", floatingText: "Password")
        self.setTextFieldUI(textField: txtFieldConfirmPassword, place: "Confirm password*", floatingText: "Confirm password")
    }
    
    //   MARK: - @IBACtions
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
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
    
    @IBAction func btnSecurePasswordTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtFieldPassword.isSecureTextInput.toggle()
    }
    @IBAction func btnSecureConfirmPasswordTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        txtFieldConfirmPassword.isSecureTextInput.toggle()
    }
    
    @IBAction func btnTandCTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isprivacypolicy = sender.isSelected == true ? true : false
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        self.validation()
    }
//    MARK: - Validation
    
    func validation(){
        if String.getString(self.txtFieldPassword.text).isEmpty{
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                showSimpleAlert(message: Notifications.kPassword)
            }
            else{
                showSimpleAlert(message: Notifications.karPassword)
            }
         
          return
      }
        else if !String.getString(txtFieldPassword.text).isValidPassword()
        {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: Notifications.kValidPassword)
            }
            else{
                self.showSimpleAlert(message: Notifications.karValidPassword)
            }
            
            return
        }
        else if String.getString(txtFieldConfirmPassword.text).isEmpty {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: Notifications.kConfirmPassword)
            }
            else{
                self.showSimpleAlert(message: Notifications.karConfirmPassword)
            }
           
            return
        }
        else if(txtFieldPassword.text != self.txtFieldConfirmPassword.text)
        {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: Notifications.kMatchPassword)
            }
            else{
                self.showSimpleAlert(message: Notifications.karMatchPassword)
            }
           
            return
        }
        else if self.isprivacypolicy == false{
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: "Please Select T&C and Privacy Policy")
            }
            else{
                self.showSimpleAlert(message: "يرجى تحديد الشروط والأحكام وسياسة الخصوصية")
            }
           
            return
        }
        self.view.endEditing(true)
        self.createAccountapi()
    }
}

// MARK: - Textfield Delegate

extension EnterPasswordVC{
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
extension EnterPasswordVC : SKFlaotingTextFieldDelegate {
    
    func textFieldDidEndEditing(textField: SKFloatingTextField) {
        print("end editing")
    }
    
    func textFieldDidChangeSelection(textField: SKFloatingTextField) {
        self.checkPass = textField.text ?? ""
        
        switch textField{
            
        case txtFieldPassword:
            
            if (self.checkPass.filter{$0.isLowercase}.count != 0) && (self.checkPass.filter{$0.isUppercase}.count != 0){
                print("lowercase",self.checkPass)
                self.imgCheckupperandlowerChar.image = UIImage(named: "Box")
            }
            else{
                self.imgCheckupperandlowerChar.image = UIImage(named: "Check")
            }
            
            if (self.checkPass.filter{$0.isNumber}.count != 0){
                print("number", self.checkPass)
                self.imgCheckNumberChar.image  = UIImage(named: "Box")
            }
            else{
                self.imgCheckNumberChar.image = UIImage(named: "Check")
            }
            
            if (self.checkPass.filter{$0.isPunctuation}.count != 0){
                print("Special Character",self.checkPass)
                self.imgCheckSpecialChar.image = UIImage(named: "Box")
            }
            else{
                self.imgCheckSpecialChar.image = UIImage(named: "Check")
            }
            
            if (self.checkPass.count >= 8) == true{
                self.imgCheckSixChar.image = UIImage(named: "Box")
            }
            else{
                self.imgCheckSixChar.image = UIImage(named: "Check")
            }
            
        default:
            UITextField()
        }
       
//        let lowercase = self.checkPass.filter{$0.isLowercase}.count
//        print("lowercase",lowercase)
//        let uppercase = self.checkPass.filter{$0.isUppercase}.count
//        print("Upercase",uppercase)
//        let number = self.checkPass.filter{$0.isNumber}.count
//        print("number", number)
//        let special = self.checkPass.filter{$0.isPunctuation}.count
//        print("Special Character",special)
    }
    
    func textFieldDidBeginEditing(textField: SKFloatingTextField) {
        print("begin editing")
    }
    
}

//  MARK: - API CALL

extension EnterPasswordVC{

//    Create Account api
    func createAccountapi(){

        CommonUtils.showHud(show: true)
        let params: [String:Any] = [
            "firstname":String.getString(self.name),
            "lastname":String.getString(self.lastame),
            "email":String.getString(self.email),
            "user_country":String.getString(self.country),
            "state":String.getString(self.state),
            "locality":String.getString(self.locality),
            "phone":String.getString(self.phone),
            "device_type":"1",
            "device_id":kSharedUserDefaults.getDeviceToken(),
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
                        vc.email = String.getString(self.email)
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
//                    if Int.getInt(dictResult["status"]) == 400{
//                        let response = kSharedInstance.getDictionary(dictResult["response"])
//
//                        if let _ = response["email"] {
//                            let msg = kSharedInstance.getStringArray(response["email"])
//                            CommonUtils.showError(.info, msg[0])// msg is on 0th index
//                        }
//                        else if let _ = response["phone"] {
//                            let msg = kSharedInstance.getStringArray(response["phone"])
//                            CommonUtils.showError(.info, msg[0])// msg is on 0th index
//                        }
//                        //let msg = kSharedInstance.getStringArray(response["phone"])
//                        // CommonUtils.showError(.info, msg[0])// msg is on 0th index
//                    }

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
//   terms and condition  Api
    
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
//                CommonUtils.showToastForDefaultError()
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
//                CommonUtils.showToastForDefaultError()
            }
        }
    }
}
// MARK: - Localisationand
extension EnterPasswordVC{
    func setuplanguage(){
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Set up a password", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "To allow you to sign in on multiple devices, you will need a password.", comment: "")
        txtFieldPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password*", comment: "")
        txtFieldPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password*", comment: "")
        txtFieldPassword.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password*", comment: "")
        txtFieldPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Confirm password*", comment: "")
        lblCheckEightChar.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "At least 8 Characters", comment: "")
        lblCheckupperandlowerChar.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Upper and lowercase Characters", comment: "")
        lblCheckNumberChar.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Numbers", comment: "")
        lblCheckSpecialChar.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Special Characters", comment: "")
        lblPlsAccept.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please accept our", comment: "")
        btnTandC.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "T&C", comment: ""), for: .normal)
        lbland.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "and", comment: "")
        btnPrivacyPolicy.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Privacy Policy", comment: ""), for: .normal)
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Continue", comment: ""), for: .normal)
    }
}

