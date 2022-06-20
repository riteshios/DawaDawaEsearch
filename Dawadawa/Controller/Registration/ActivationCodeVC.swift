//
//  ActivationCodeVC.swift
//  Dawadawa
//
//  Created by Alekh Verma on 10/06/22.
//

import UIKit

class ActivationCodeVC: UIViewController{

    @IBOutlet weak var lblWrongCode: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
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
    @IBOutlet weak var viewOtp5: UIView!
    @IBOutlet weak var viewOtp6: UIView!
    
    
    var callback:(()->())?
    var type:HasCameFrom?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .signUp{
            self.lblHeading.text = "Activate account"
            self.lblSubHeading.text = "An account activation code has been sent to your email address and phone number"
        }
        else if type == .forgotPass{
            self.lblHeading.text = "Verify Account"
            self.lblSubHeading.text = "Password reset code is sent on your phone number 75******67"
        }

     
        self.lblWrongCode.isHidden = true
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
    }
    
  
    @IBAction func buttonVerify(_ sender: UIButton) {
        self.callback?()
//            guard let vc = self.storyboard?.instantiateViewController(identifier: "ActivatedSuccessfullyPopUpVC") as? ActivatedSuccessfullyPopUpVC else {return}
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true)
        
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

extension ActivationCodeVC: UITextFieldDelegate{
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
        
        default:
            return
       }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        switch textField{
//        case self.txtfieldOtp1:
//            self.viewOtp1.borderColor = UIColor(hexString: "#A6A6A6")
//
//        case self.txtfieldOtp2:
//            self.viewOtp2.borderColor = UIColor(hexString: "#A6A6A6")
//
//        case self.txtfieldOtp3:
//            self.viewOtp3.borderColor = UIColor(hexString: "#A6A6A6")
//
//        case self.txtfieldOtp4:
//            self.viewOtp4.borderColor = UIColor(hexString: "#A6A6A6")
//
//        case self.txtfieldOtp5:
//            self.viewOtp5.borderColor = UIColor(hexString: "#A6A6A6")
//
//        case self.txtfieldOtp6:
//            self.viewOtp6.borderColor = UIColor(hexString: "#A6A6A6")
//
//
//        default:
//            return
//       }
//    }
}
