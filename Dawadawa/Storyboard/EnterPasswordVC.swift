//  EnterPasswordVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/12/22.

import UIKit
import SKFloatingTextField

class EnterPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    @IBOutlet weak var viewContinue: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
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
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
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
        print("changing text")
    }
    
    func textFieldDidBeginEditing(textField: SKFloatingTextField) {
        print("begin editing")
    }
}

// API CALL

extension EnterPasswordVC{
    
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


