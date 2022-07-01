//
//  ChangeEmailVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit
import SKFloatingTextField

class ChangeEmailVC: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: SKFloatingTextField!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSendCode: UIView!
    var callbackchangenumber:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    //  MARK: - Life Cycle
    func setup(){
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewSendCode.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtFieldEmail, place: "Enter new email address ", floatingText: "Enter new email address ")
    }
    //    MARK: - @IBAction
    @IBAction func btnSendCodeTapped(_ sender: UIButton) {
        self.fieldvalidationEmailAdress()
    }
    // MARK: -  Validation
    
    func fieldvalidationEmailAdress(){
        if String.getString(self.txtFieldEmail.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterEmail)
            return
        }
        else if !String.getString(txtFieldEmail.text).isEmail()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidEmail)
            return
        }
        self.view.endEditing(true)
        self.changeemailapi()
    }
    
}

extension ChangeEmailVC{
    
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
extension ChangeEmailVC : SKFlaotingTextFieldDelegate {
    
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

extension ChangeEmailVC{
    func changeemailapi(){
        
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
            
            
        let params:[String : Any] = [
            "email":String.getString(self.txtFieldEmail.text),
            "user_id":UserData.shared.id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kchangeemail, requestMethod: .POST,
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
                        self?.callbackchangenumber?(self?.txtFieldEmail.text ?? "")
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
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
}
