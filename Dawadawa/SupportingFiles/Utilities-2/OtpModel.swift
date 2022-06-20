

import Foundation
import UIKit
typealias Dict = [String:Any]
var mytemp = 0

@objc protocol OTPViewModelDelegate {
    func requestSent(isVerified: Bool, response:Dict)
}

class OTPViewModel: NSObject {
    weak var delegate: OTPViewModelDelegate?
    var textFieldsOTP: [UITextField] = []
     var textFieldsConfirmOTP: [UITextField] = []
    var type = 0
    
    func configure(textFields: [UITextField],type:Int) {
        self.textFieldsOTP = textFields
        self.textFieldsOTP.forEach { $0.delegate = self}
    }
    
    func confirmOTP() {
        let validates = self.validateFields()
        if validates.isValid {
            self.sendOTP(otp: validates.otp)
        }
    }
    
    
    private func validateFields() -> (isValid: Bool, otp: String) {
        let texts = self.textFieldsOTP.map { String.getString($0.text)}
        
        if !(texts.filter{ $0.isEmpty }).isEmpty {
            CommonUtils.showError(.warning, "Please enter OTP")
           
            return (isValid: false, otp: "")
        } else {
            
            let otp = texts.reduce(into: "", { return $0 = $0 + $1 })
            return (isValid: true, otp: otp)
            
        }
    }
    
    private func clearFields() {
        self.textFieldsOTP.forEach { $0.text = ""}
    }
    
    deinit {
        print("deinit")
        self.textFieldsOTP = []
    }
}


extension OTPViewModel: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let texts = self.textFieldsOTP.map { String.getString($0.text)}
        var shouldBegin    = false
        shouldBegin = (texts[0 ..< textField.tag].filter { $0.isEmpty }).isEmpty
        if shouldBegin {
            textField.text  = " "
        }
        return shouldBegin
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.tag < self.textFieldsOTP.count else {return false}
        if string.isBackspace() {
            return self.backSpaceAction(forTextField: textField)
        } else {
            textField.text  = string
            
            switch textField.tag {
            case textFieldsOTP.count - 1:
                textField.resignFirstResponder()
                return true
            case let value where value < textFieldsOTP.count:
                textFieldsOTP[value + 1].becomeFirstResponder()
                return true
            default:
                return true
            }
            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
     func textFieldDidEndEditing(_ textField: UITextField) {
         if textField.text?.count == 0{
             textField.placeholder = "*"
         }else{
             textField.placeholder = ""
         }
     }
    
    func backSpaceAction(forTextField textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 0:
            textField.text = " "
            return false
        case let value where value < textFieldsOTP.count:
            textField.text = " "
            textFieldsOTP[value - 1].becomeFirstResponder()
            return false
        default:
            return true
        }
        
    }
}


//MARK:- API Integration
extension OTPViewModel {
    func sendOTP(otp: String) {
//         let userDeatils = kSharedUserDefaults.getLoggedInUserDetails()
//        let parameters: [String : Any]      = [ ApiParameters.verification_code: String.getString(otp),
//                                                ApiParameters.mobile_number: String.getString(userDeatils[ApiParameters.mobile_number]),
//                                                ApiParameters.country_code : String.getString(userDeatils[ApiParameters.country_code])
//                                              ]
//        CommonUtils.showHudWithNoInteraction(show: true)
//        BaseController.shared.postToServerAPI(url: ServiceName.otp_verify, params: parameters, type: .POST, completionHandler: {(dicResponse) in
//            self.delegate?.requestSent(isVerified: true, response: dicResponse)
//        })
         self.delegate?.requestSent(isVerified: true, response: [:])
   }
   
}

extension String {
    func isBackspace() -> Bool {
        if let char = self.cString(using: String.Encoding.utf8) {
            return strcmp(char, "\\b") == -92
        } else {
            return false
        }
    }
}
