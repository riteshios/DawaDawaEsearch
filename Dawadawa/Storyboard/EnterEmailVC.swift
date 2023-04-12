//  EnterEmailVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.


import UIKit
import SKFloatingTextField

class EnterEmailVC: UIViewController {
    
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtfldEmail: SKFloatingTextField!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    var name = ""
    var lastame = ""
    var usertype = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
        self.lblName.text = self.name
    }
    
    override func viewWillLayoutSubviews() {
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            DispatchQueue.main.async {
                self.txtfldEmail.semanticContentAttribute = .forceLeftToRight
                self.txtfldEmail.textAlignment = .left
            }
            
        } else {
            DispatchQueue.main.async {
                self.txtfldEmail.semanticContentAttribute = .forceRightToLeft
                self.txtfldEmail.textAlignment = .right
            }
        }
    }
    
    
    //    MARK: - Life Cycle -
    
    func setup(){
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtfldEmail, place: "Email*", floatingText: "Email")
    }
    
    //     MARK: - @IBACtion
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        self.validation()
    }
    
    
    // MARK: - Validation
    
    func validation(){
        
        if String.getString(self.txtfldEmail.text).isEmpty
        {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                showSimpleAlert(message: Notifications.kEnterEmail)
            }
            else{
                showSimpleAlert(message: Notifications.karEnterEmail)
            }
            return
        }
        else if !String.getString(txtfldEmail.text).isValidEmail()
        {
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: Notifications.kEnterValidEmail)
            }
            else{
                self.showSimpleAlert(message: Notifications.karEnterValidEmail)
            }
            return
        }
        self.view.endEditing(true)
        self.checkemailapi()
    }
}

extension EnterEmailVC{
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
extension EnterEmailVC : SKFlaotingTextFieldDelegate {
    
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

//    MARK: - Api call -

extension EnterEmailVC{
    
    //   Check Email Address
    
    func checkemailapi(){
        
        CommonUtils.showHud(show: true)
        let params: [String:Any] = [
            "email": String.getString(self.txtfldEmail.text)
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kcheckemail, requestMethod: .POST, requestParameters: params, withProgressHUD: false) { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode){
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPhoneNumberVC") as! EnterPhoneNumberVC
                        vc.name = self.name
                        vc.lastame = self.lastame
                        vc.usertype = self.usertype
                        vc.email = self.txtfldEmail.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else if Int.getInt(dictResult["status"]) == 400{
                        if kSharedUserDefaults.getlanguage() as? String == "en" {
                            self.showSimpleAlert(message: "The email has already been taken.")
                        }
                        else{
                            self.showSimpleAlert(message: "البريد الإلكتروني تم أخذه.")
                        }
                    }
                    //
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //    CommonUtils.showToastForDefaultError()
            }
        }
    }
}

// MARK: - Localisation

extension EnterEmailVC{
    
    func setuplanguage(){
        lblHello.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Hello", comment: "")
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please enter your email address that you would like to sign into DawaDawa.", comment: "")
        txtfldEmail.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email*", comment: "")
        txtfldEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email*", comment: "")
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Continue", comment: ""), for: .normal)
        
    }
}

