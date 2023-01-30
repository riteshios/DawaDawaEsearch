//  EnterNameVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.

import UIKit
import SKFloatingTextField

class EnterNameVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblYouwant: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    @IBOutlet weak var txtFieldFirstName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLastName: SKFloatingTextField!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var btnDropUserType: UIButton!
    @IBOutlet weak var viewContinue: UIView!
    
    var usertype = 0
    var isSelectuser = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
    }
// MARK: - Life Cycle
    
    func setup(){
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtFieldFirstName, place: "First name*", floatingText: "First name")
        self.setTextFieldUI(textField: txtFieldLastName, place: "Last name*", floatingText: "Last name")
    }
    
//    MARK: - @IBACtion
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func btnSelectUserTypeTapped(_ sender: UIButton){
        let dataSource1 = ["Investor","Business Owner","Service Provider"]
        kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropUserType)
        {(Index ,item) in
            self.lblUserType.text = item
            self.usertype = Index
            self.isSelectuser = true
            debugPrint("usertpe=-=-=",self.usertype)
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
//        self.validation()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterEmailVC") as! EnterEmailVC
        vc.name = self.txtFieldFirstName.text ?? ""
        vc.lastame = self.txtFieldLastName.text ?? ""
        vc.usertype = self.usertype
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    MARK: - Validation
    
    func validation(){
        
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
        else if self.isSelectuser == false{
            self.showSimpleAlert(message: "Please Select Who Are you")
        }
        
        self.view.endEditing(true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterEmailVC") as! EnterEmailVC
        vc.name = self.txtFieldFirstName.text ?? ""
        vc.lastame = self.txtFieldLastName.text ?? ""
        vc.usertype = self.usertype
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Textfield Delegate

extension EnterNameVC{
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
extension EnterNameVC : SKFlaotingTextFieldDelegate {
    
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

// MARK: - Localisation

extension EnterNameVC{
    func setuplanguage(){
        txtFieldFirstName.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "First name", comment: "")
        txtFieldFirstName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "First name", comment: "")
        txtFieldLastName.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last name", comment: "")
        txtFieldLastName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last name", comment: "")
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter your first name and last name", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please enter your legal name that will be associated with your account.", comment: "")
        lblYouwant.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "You want to be?", comment: "")
        lblUserType.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select user type", comment: "")
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Continue", comment: ""), for: .normal)
    }
}
