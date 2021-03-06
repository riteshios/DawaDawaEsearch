//
//  VerifyEmailOTPVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit

class VerifyEmailOTPVC: UIViewController {
    
    //     MARK: - Properties
    @IBOutlet weak var lblWrongCode: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var txtfieldOtp1: UITextField!
    @IBOutlet weak var txtfieldOtp2: UITextField!
    @IBOutlet weak var txtfieldOtp3: UITextField!
    @IBOutlet weak var txtfieldOtp4: UITextField!
    @IBOutlet weak var txtfieldOtp5: UITextField!
    @IBOutlet weak var txtfieldOtp6: UITextField!
    
    @IBOutlet weak var viewOtp1: UIView!
    @IBOutlet weak var viewOtp2: UIView!
    @IBOutlet weak var viewOtp3: UIView!
    @IBOutlet weak var viewOtp4: UIView!
    @IBOutlet weak var viewOtp6: UIView!
    @IBOutlet weak var viewOtp5: UIView!
    @IBOutlet weak var viewVerify: UIView!
    
    var callbackOTP1:(()->())?
    var otp = ""
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: -Life Cycle
    
    func setup(){
        self.lblWrongCode.isHidden = true
        self.lblSubHeading.text = "Phone number verification code is sent on your email \(String.getString(self.email))"
        self.txtfieldOtp1.delegate = self
        self.txtfieldOtp2.delegate = self
        self.txtfieldOtp3.delegate = self
        self.txtfieldOtp4.delegate = self
        self.txtfieldOtp5.delegate = self
        self.txtfieldOtp6.delegate = self
        
        self.viewOtp1.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewOtp2.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewOtp3.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewOtp4.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewOtp5.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewOtp6.borderColor = UIColor(hexString: "#A6A6A6")
        self.viewVerify.backgroundColor = UIColor(hexString: "#A6A6A6")
    }
    
    func changebordercolor(){
        
        self.viewOtp1.borderColor = UIColor(hexString: "#FF4C4D")
        self.viewOtp2.borderColor = UIColor(hexString: "#FF4C4D")
        self.viewOtp3.borderColor = UIColor(hexString: "#FF4C4D")
        self.viewOtp4.borderColor = UIColor(hexString: "#FF4C4D")
        self.viewOtp5.borderColor = UIColor(hexString: "#FF4C4D")
        self.viewOtp6.borderColor = UIColor(hexString: "#FF4C4D")
    }
    
    
    @IBAction func BtnVerifyTapped(_ sender: UIButton) {
        self.otp = String.getString(self.txtfieldOtp1.text) + String.getString(self.txtfieldOtp2.text) + String.getString(self.txtfieldOtp3.text) + String.getString(self.txtfieldOtp4.text) +
        String.getString(self.txtfieldOtp5.text) +
        String.getString(self.txtfieldOtp6.text)
        if !otp.isEmpty{
            self.verifyemailotpapi()
        }
        else{
            CommonUtils.showError(.info, "Please enter otp")
            return
        }
        
    }
    
    @IBAction func btnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func BtnAResendTapped(_ sender: UIButton) {
        self.resendOtpApi()
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string.count == 1){
            if textField == txtfieldOtp1 {
                txtfieldOtp2?.becomeFirstResponder()
            }
            if textField == txtfieldOtp2 {
                txtfieldOtp3?.becomeFirstResponder()
            }
            if textField == txtfieldOtp3 {
                txtfieldOtp4?.becomeFirstResponder()
            }
            if textField == txtfieldOtp4 {
                txtfieldOtp5?.becomeFirstResponder()
            }
            if textField == txtfieldOtp5{
                txtfieldOtp6?.becomeFirstResponder()
            }
            if textField == txtfieldOtp6{
                txtfieldOtp6?.resignFirstResponder()
            }
            
            textField.text? = string
            return false
        }else{
            if textField == txtfieldOtp1 {
                txtfieldOtp1?.becomeFirstResponder()
            }
            if textField == txtfieldOtp2 {
                txtfieldOtp1.becomeFirstResponder()
            }
            if textField == txtfieldOtp3 {
                txtfieldOtp2?.becomeFirstResponder()
            }
            if textField == txtfieldOtp4 {
                txtfieldOtp3?.becomeFirstResponder()
            }
            if textField == txtfieldOtp5{
                txtfieldOtp4?.becomeFirstResponder()
            }
            if textField == txtfieldOtp6{
                txtfieldOtp5?.becomeFirstResponder()
            }
            textField.text? = string
            return false
        }
    }
}

// MARK: - TextField Delegate

extension VerifyEmailOTPVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        switch textField{
        case self.txtfieldOtp1:
            self.viewOtp1.borderColor = UIColor(hexString: "#1572A1")
            //            self.textFieldPhoneNumber.textColor = UIColor(hexStrin
            
        case self.txtfieldOtp2:
            self.viewOtp2.borderColor = UIColor(hexString: "#1572A1")
            
        case self.txtfieldOtp3:
            self.viewOtp3.borderColor = UIColor(hexString: "#1572A1")
            
        case self.txtfieldOtp4:
            self.viewOtp4.borderColor = UIColor(hexString: "#1572A1")
            
        case self.txtfieldOtp5:
            self.viewOtp5.borderColor = UIColor(hexString: "#1572A1")
            
        case self.txtfieldOtp6:
            self.viewOtp6.borderColor = UIColor(hexString: "#1572A1")
            self.viewVerify.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        default:
            return
        }
            
        
    }
}

// MARK: - API call

extension VerifyEmailOTPVC{
    func verifyemailotpapi(){
        
        CommonUtils.showHud(show: true)
        
        let params:[String : Any] = [
            "email":String.getString(self.email),
            "otp":self.otp]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kOtpVerify, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        self?.callbackOTP1?()
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.lblWrongCode.isHidden = false
                        self?.changebordercolor()
                        
                    }
                    else if Int.getInt(dictResult["status"]) == 403{
                        let response = kSharedInstance.getDictionary(dictResult["response"])
                        let msg = kSharedInstance.getStringArray(response["otp"])
                        CommonUtils.showError(.info, msg[0])// msg is on 0th index
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
    func resendOtpApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String : Any] = [
            "email":UserData.shared.email
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kresendotp,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                default:
                    
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    
                }
            }
            else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
}
