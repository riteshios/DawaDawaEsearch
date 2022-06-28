//
//  CreateAccountVC.swift
//  Dawadawa
//

//  Created by Alekh Verma on 09/06/22.
//

import UIKit
import SKFloatingTextField


class CreateAccountVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var viewCreateAccountButton: UIView!
    @IBOutlet weak var btnCountrySelect: UIButton!
    
    
    @IBOutlet weak var txtFieldFirstName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLastName: SKFloatingTextField!
    @IBOutlet weak var txtFieldEmail: SKFloatingTextField!
    @IBOutlet weak var txtFieldPhoneNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldPassword: SKFloatingTextField!
    @IBOutlet weak var txtFieldConfirmPassword: SKFloatingTextField!
    
    @IBOutlet weak var viewCountry: UIView!
    
    
    
    var isCountry = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
       
        
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
        
        self.viewCountry.isHidden = true
    }
    //   MARK: - @IBACtions
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
    
    //    @IBAction func btnSecurePasswordTapped(_ sender: UIButton) {
    //        sender.isSelected = !sender.isSelected
    //        txtFieldPassword.isSecureTextEntry.toggle()
    //    }
    //    @IBAction func btnSecureConfirmPasswordTapped(_ sender: UIButton){
    //        sender.isSelected = !sender.isSelected
    //        txtFieldConfirmPassword.isSecureTextEntry.toggle()
    //    }
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: UIButton){
        self.Validation()
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
        else if self.isCountry == false{
            self.showSimpleAlert(message: "Please Select the Country")
        }
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
        self.view.endEditing(true)
        self.createAccountapi()
    }
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
            "confirm_password":String.getString(self.txtFieldConfirmPassword.text)
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
                                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                                        self.navigationController?.pushViewController(vc, animated: true)
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
}

