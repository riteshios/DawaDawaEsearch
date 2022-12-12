//  EnterPhoneNumberVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.

import UIKit
import SKFloatingTextField

class EnterPhoneNumberVC: UIViewController {
    
    @IBOutlet weak var txtfieldPhoneNumber: SKFloatingTextField!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btnCountrySelect: UIButton!
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelCountryCode: UILabel!
    
    @IBOutlet weak var viewContinue: UIView!
    
    var name = ""
    var lastame = ""
    var usertype = 0
    var email = ""
    
    
    //    MARK:  -Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblname.text = self.name
        self.setup()
    }
    
    func setup(){
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtfieldPhoneNumber, place: "Phone Number*", floatingText: "Phone Number")
    }
    
    //    MARK: - @IBAction
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountrySelecTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //        if self.btnCountrySelect.isSelected == true{
        //            self.viewCountry.isHidden = false
        //        }
        AppsCountryPickerInstanse.sharedInstanse.showController(referense: self) { (selectedCountry) in
            
            self.labelCountry.text = selectedCountry?.name
            self.labelCountryCode.text = selectedCountry?.countryCode
            self.imageFlag.image = selectedCountry?.image ?? UIImage()
            //            self.isCountry = true
        }
    }
    
    @IBAction func btnContinueTapped(_ sender : UIButton) {
        self.validation()
    }
    
    
    // MARK: - Validation
    
    func validation(){
        
        if String.getString(self.txtfieldPhoneNumber.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterMobileNumber)
            return
        }
        else if !String.getString(txtfieldPhoneNumber.text).isPhoneNumber()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidMobileNumber)
            
        }
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterResidenceVC") as! EnterResidenceVC
        vc.name = self.name
        vc.lastame = self.lastame
        vc.usertype = self.usertype
        vc.email = self.email
        vc.phone = self.txtfieldPhoneNumber.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension EnterPhoneNumberVC{
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
extension EnterPhoneNumberVC : SKFlaotingTextFieldDelegate {
    
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
