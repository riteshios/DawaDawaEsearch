//
//  EditProfileVC.swift
//  Dawadawa
//
//  Created by Alekh on 27/06/22.
//

import UIKit
import SKFloatingTextField


class EditProfileVC: UIViewController {

    @IBOutlet weak var txtFieldPhoneNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldEmailAddress: SKFloatingTextField!
    @IBOutlet weak var txtFieldFirstName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLastName: SKFloatingTextField!
    @IBOutlet weak var txtFieldDOB: SKFloatingTextField!
    @IBOutlet weak var txtFieldWhatsappNumber: SKFloatingTextField!
    
    @IBOutlet weak var ViewSaveChange: UIView!
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var btnDropGender: UIButton!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblArabic: UILabel!
    @IBOutlet weak var btnDropUserType: UIButton!
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var btnSelectCountry: UIButton!
    var userdata = [UserData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchdata()
    }
    
    func setup(){
        self.setTextFieldUI(textField: txtFieldPhoneNumber, place: "", floatingText: "Phone number")
        self.setTextFieldUI(textField: txtFieldEmailAddress, place: "", floatingText: "Email address")
        self.setTextFieldUI(textField: txtFieldFirstName, place: "", floatingText: "First name")
        self.setTextFieldUI(textField: txtFieldLastName, place: "", floatingText: "Last name")
        self.setTextFieldUI(textField: txtFieldDOB, place: "", floatingText: "Date of birth")
        self.setTextFieldUI(textField: txtFieldWhatsappNumber, place: "", floatingText: "Whatsapp number")
        
        self.ViewSaveChange.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
     
        self.viewEnglish.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
        self.lblEnglish.textColor = UIColor.systemBackground
        self.lblArabic.textColor = UIColor(red: 21, green: 114, blue: 161)

    }
    func fetchdata(){
        self.txtFieldFirstName.text  = UserData.shared.name
        self.txtFieldLastName.text = UserData.shared.last_name
        self.txtFieldPhoneNumber.text = UserData.shared.phone
        self.txtFieldEmailAddress.text = UserData.shared.email
        self.txtFieldWhatsappNumber.text = UserData.shared.whatspp_number
        self.txtFieldDOB.text = UserData.shared.dob
        self.lblCountry.text = UserData.shared.user_country
        self.lblGender.text = UserData.shared.user_gender
        self.lblUserType.text = UserData.shared.user_type
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnChangePhoneNumberTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: VerifyNumberOTPVC.getStoryboardID()) as! VerifyNumberOTPVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
//        vc.email = String.getString(self?.txtFieldPhone_Email.text)
        vc.callbackOTP1 =
        {
            vc.dismiss(animated: false){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangeNumberVC.getStoryboardID()) as! ChangeNumberVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callbackchangenumber = {
                    self.dismiss(animated: false) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: VerifyNewNumberOTPVC.getStoryboardID()) as! VerifyNewNumberOTPVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.callbackOTP2 = {
                            self.dismiss(animated: false){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: NumberChangedSuccessfulPopUpVC.getStoryboardID()) as! NumberChangedSuccessfulPopUpVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.callbackpopup = {
                                    self.dismiss(animated: false){
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                                self.present(vc, animated: false)
                            }
                        }
                        self.present(vc, animated: false)
                    }
                }
                self.present(vc, animated: false)
            }
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func btnChangeEmailTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: VerifyEmailOTPVC.getStoryboardID()) as! VerifyEmailOTPVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
//        vc.email = String.getString(self?.txtFieldPhone_Email.text)
        vc.callbackOTP1 =
        {
            vc.dismiss(animated: false){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangeEmailVC.getStoryboardID()) as! ChangeEmailVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callbackchangenumber = {
                    self.dismiss(animated: false) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: VerifyNewEmailOTPVC.getStoryboardID()) as! VerifyNewEmailOTPVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.callbackOTP2 = {
                            self.dismiss(animated: false){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: EmailChangedSuccessfullyPopUpVC.getStoryboardID()) as! EmailChangedSuccessfullyPopUpVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.callbackpopup = {
                                    self.dismiss(animated: false){
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                                self.present(vc, animated: false)
                            }
                        }
                        self.present(vc, animated: false)
                    }
                }
                self.present(vc, animated: false)
            }
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func btnDropGender(_ sender: UIButton){
        let dataSource1 = ["Male","Female"]
               kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropGender)
               {(Index ,item) in
                   self.lblGender.text = item
               }
        
    }
    @IBAction func btnDropSelectUserType(_ sender: UIButton){
        let dataSource1 = ["Business Owner","Service Provider","Investor"]
        kSharedAppDelegate?.dropDown(dataSource:self.userdata.map{String.getString($0.user_type)} , text: btnDropUserType)
               {(Index ,item) in
                   self.lblUserType.text = String.getString(item)
               }
    }
    @IBAction func btnSelectCountryTapped(_ sender: UIButton) {
        AppsCountryPickerInstanse.sharedInstanse.showController(referense: self) { (selectedCountry) in
            
            self.lblCountry.text = selectedCountry?.name
            self.imageFlag.image = selectedCountry?.image ?? UIImage()
        }
    }
    
    
}
extension EditProfileVC{
    
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
extension EditProfileVC : SKFlaotingTextFieldDelegate {
    
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
