//  EditProfileVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 27/06/22.

import UIKit
import SKFloatingTextField
import IQKeyboardManagerSwift

class EditProfileVC: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet weak var textfieldDATE: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldEmailAddress: SKFloatingTextField!
    @IBOutlet weak var txtFieldFirstName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLastName: SKFloatingTextField!
    //    @IBOutlet weak var txtFieldDOB: SKFloatingTextField!
    @IBOutlet weak var txtFieldWhatsappNumber: SKFloatingTextField!
    @IBOutlet weak var txtfieldEnterAbout: IQTextView!
    
    @IBOutlet weak var ViewSaveChange: UIView!
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewWhatsappNumber: UIView!
    @IBOutlet weak var viewDOB: UIView!
    
    @IBOutlet weak var btnDropGender: UIButton!
    
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnArabic: UIButton!
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var btnSelectCountry: UIButton!
    
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnLocality: UIButton!
    
    @IBOutlet weak var lblEditProfile: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblChangePhone: UILabel!
    @IBOutlet weak var lblChangeEmail: UILabel!
    @IBOutlet weak var lblEmailaddress: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblheadingCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblArabic: UILabel!
    @IBOutlet weak var lblWhatsNumber: UILabel!
    @IBOutlet weak var btnSaveChanges: UIButton!
 
    
    var getstatelistarr        =      [getstateModel]()
    var getlocalitylistarr     =      [getlocalityModel]()
    var stateid:Int?
    var localityid:Int?
    
    var userdata = [UserData]()
    var timePicker = UIDatePicker()
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setupdate()
        self.setup()
        if UserData.shared.isskiplogin == true{
            print("hghjj")
            self.txtFieldFirstName.placeholder = "XYZ"
            self.txtFieldLastName.placeholder = "XYZ"
            self.txtFieldPhoneNumber.placeholder = "91***********"
            self.txtFieldEmailAddress.placeholder = "examiple@.com"
            self.txtFieldWhatsappNumber.placeholder = "+91**********"
            self.textfieldDATE.placeholder = "DD/MM/YYYY"
            self.lblCountry.text = "India"
        }
        else{
            self.fetchdata()
            self.getstateapi()
        }
    }
    
    //    MARK: - Life Cycle
    
    func setup(){
        self.setTextFieldUI(textField: txtFieldPhoneNumber, place: "", floatingText: "Phone number")
        self.setTextFieldUI(textField: txtFieldEmailAddress, place: "", floatingText: "Email address")
        self.setTextFieldUI(textField: txtFieldFirstName, place: "", floatingText: "First name")
        self.setTextFieldUI(textField: txtFieldLastName, place: "", floatingText: "Last name")
        //        self.setTextFieldUI(textField: txtFieldDOB, place: "", floatingText: "Date of birth")
        self.setTextFieldUI(textField: txtFieldWhatsappNumber, place: "", floatingText: "Whatsapp number")
        
        self.ViewSaveChange.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        if self.btnEnglish.isSelected == true{
            self.viewEnglish.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblArabic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblEnglish.textColor = UIColor.systemBackground
            self.viewArabic.backgroundColor = UIColor.systemBackground
        }
        else{
            self.viewArabic.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblEnglish.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblArabic.textColor = UIColor.systemBackground
            self.viewEnglish.backgroundColor = UIColor.systemBackground
        }
        self.viewEnglish.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
        self.lblArabic.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.lblEnglish.textColor = UIColor.systemBackground
        self.viewArabic.backgroundColor = UIColor.systemBackground
        
        self.txtFieldPhoneNumber.delegate = self
        self.txtFieldEmailAddress.delegate = self
        //        self.txtFieldDOB.delegate = self
        self.txtFieldFirstName.delegate = self
        self.txtFieldLastName.delegate = self
        self.txtFieldWhatsappNumber.delegate = self
        
        self.viewPhone.isHidden = false
        self.viewEmail.isHidden = false
        self.viewDOB.isHidden = false
        self.viewFirstName.isHidden = false
        self.viewLastName.isHidden = false
        self.viewWhatsappNumber.isHidden = false
        self.txtFieldWhatsappNumber.keyBoardType = .numberPad
        self.txtFieldPhoneNumber.isUserInteractionEnabled = false
        self.txtFieldEmailAddress.isUserInteractionEnabled = false
        
    }
    
    func fetchdata(){
        self.txtFieldFirstName.text  = UserData.shared.name
        self.txtFieldLastName.text = UserData.shared.last_name
        self.txtFieldPhoneNumber.text = UserData.shared.phone
        self.txtFieldEmailAddress.text = UserData.shared.email
        debugPrint("email....",UserData.shared.email)
        
        if UserData.shared.whatspp_number != ""{
            self.txtFieldWhatsappNumber.text = UserData.shared.whatspp_number
        }
        if UserData.shared.whatspp_number == ""{
            self.txtFieldWhatsappNumber.placeholder = "+91111111111"
        }
        
        if UserData.shared.dob == ""{
            self.textfieldDATE.placeholder = "DD/MM/YYYY"
        }
        if UserData.shared.dob != ""{
            self.textfieldDATE.text = UserData.shared.dob
        }
        
        if UserData.shared.user_country != ""{
            self.lblCountry.text = UserData.shared.user_country
            debugPrint("self.lblCountry.text==",self.lblCountry.text)
        }
        
        if UserData.shared.user_gender != ""{
            self.lblGender.text = UserData.shared.user_gender
        }
        
        if UserData.shared.user_type != ""{
            
            if UserData.shared.user_type == "0"{
                self.lblUserType.text = "Investor"
            }
            else if UserData.shared.user_type == "1"{
                self.lblUserType.text = "Business Owner"
            }
            else if UserData.shared.user_type == "2"{
                self.lblUserType.text = "Service Provider"
            }
        }
        if UserData.shared.about != ""{
            self.txtfieldEnterAbout.text = UserData.shared.about
        }
    }
    // MARK: -   Validation
    func Validation()
    {
        
        if !String.getString(self.txtFieldFirstName.text).isValidUserName()
        {
            self.showSimpleAlert(message: Notifications.kvalidfirsname)
            return
        }
        
        else if !String.getString(txtFieldLastName.text).isValidUserName()
        {
            self.showSimpleAlert(message: Notifications.kvalidlastname)
            return
        }
        else if !String.getString(txtFieldEmailAddress.text).isEmail()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidEmail)
            return
        }
        else if !String.getString(txtFieldWhatsappNumber.text).isPhoneNumber()
        {
            self.showSimpleAlert(message: "Please Enter valid Whatsapp Number")
            return
        }
        //        else if !String.getString(textfieldDATE.text).isdob(){
        //            self.showSimpleAlert(message: "Please Enter your DOB")
        //            return
        //        }
        self.view.endEditing(true)
        self.editdetailapi()
    }
    
    // MARK: - @IBAction
    
    @IBAction func btnEnglishLanguageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEnglish.isSelected == true{
            self.viewEnglish.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblArabic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblEnglish.textColor = UIColor.systemBackground
            self.viewArabic.backgroundColor = UIColor.systemBackground
        }
        
        UserDefaults.standard.set("en", forKey: "Language")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    @IBAction func btnArabicLanguageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnArabic.isSelected == true{
            self.viewArabic.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblEnglish.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblArabic.textColor = UIColor.systemBackground
            self.viewEnglish.backgroundColor = UIColor.systemBackground
        }
        
        UserDefaults.standard.set("ar", forKey: "Language")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
    }
    //    @IBAction func btnDobTapped(_ sender: UIButton) {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
    //
    //        vc.modalTransitionStyle = .crossDissolve
    //
    //        vc.modalPresentationStyle = .overCurrentContext
    //
    //        vc.callBack = { txt in
    //
    //            vc.dismiss(animated: true) {
    //
    //                debugPrint("tettext",txt)
    //            }
    //        }
    //
    //        self.present(vc, animated: true)
    //    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        //  self.editdetailapi()
        self.Validation()
        
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
        self.verifyemail()
    }
    
    @IBAction func btnSelectStateTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getstatelistarr.map{String.getString($0.state_name)}, text: btnState){
            (index,item) in
            self.lblState.text = item
            let id = self.getstatelistarr[index].id
            self.stateid = id
            debugPrint("State idddd.....btnnnnt",  self.stateid = id)
            
            self.getlocalityapi(id: self.stateid ?? 0 )
        }
    }
    
    @IBAction func btnLocalityTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getlocalitylistarr.map{String.getString($0.local_name)}, text: btnLocality){
            (index,item) in
            self.lblLocality.text = item
            let id  = self.getlocalitylistarr[index].id
            self.localityid = id
            debugPrint("localityid....",self.localityid)
            
        }
    }
    
    @IBAction func btnDropGender(_ sender: UIButton){
        let dataSource1 = ["Male","Female"]
        kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropGender)
        {(Index ,item) in
            self.lblGender.text = item
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

extension EditProfileVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        switch textField{
        case self.txtFieldPhoneNumber:
            self.viewPhone.isHidden = true
            
        case self.txtFieldEmailAddress:
            self.viewEmail.isHidden = true
            
        case self.textfieldDATE:
            self.viewDOB.isHidden = true
            
        case self.txtFieldFirstName:
            self.viewFirstName.isHidden = true
            
        case self.txtFieldLastName:
            self.viewLastName.isHidden = true
            
        case self.txtFieldWhatsappNumber:
            self.viewWhatsappNumber.isHidden = true
            
        default:
            return
        }
    }
}

// MARK: - API Call


extension EditProfileVC{
    //    Edit Api
    func editdetailapi(){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
            //  headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        
        let params:[String : Any] = [
            "user_id":UserData.shared.id,
            "first_name":String.getString(self.txtFieldFirstName.text),
            "last_name":String.getString(self.txtFieldLastName.text),
            "whatsapp_number":String.getString(self.txtFieldWhatsappNumber.text),
            "dob":String.getString(self.textfieldDATE.text),
            "phone":String.getString(self.txtFieldPhoneNumber.text),
            "country_detail":self.lblCountry.text,
            "user_type":UserData.shared.user_type,
            "gender":self.lblGender.text,
            "about":self.txtfieldEnterAbout.text
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kedituserdetails, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        UserData.shared.saveData(data: data, token: String.getString(kSharedUserDefaults.getLoggedInAccessToken()))
                        
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: TabBarVC.getStoryboardID()) as! TabBarVC
                        self?.tabBarController?.selectedIndex = 4
                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    // send otp to email api
    func verifyemail(){
        
        CommonUtils.showHud(show: true)
        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
        
        let params:[String : Any] = [
            "email":String.getString(self.txtFieldEmailAddress.text),
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kforgotpassword, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: VerifyEmailOTPVC.getStoryboardID()) as! VerifyEmailOTPVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.email = String.getString(self?.txtFieldEmailAddress.text)
                        //        vc.email = String.getString(self?.txtFieldPhone_Email.text)
                        vc.callbackOTP1 =
                        {
                            vc.dismiss(animated: false){
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: ChangeEmailVC.getStoryboardID()) as! ChangeEmailVC
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.callbackchangenumber =  { txt in
                                    debugPrint("email===,", txt)
                                    self?.dismiss(animated: false) {
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: VerifyNewEmailOTPVC.getStoryboardID()) as! VerifyNewEmailOTPVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overCurrentContext
                                        
                                        
                                        let em:String = String(describing:txt)
                                        debugPrint("emmm",em)
                                        vc.email = em
                                        vc.callbackOTP2 = {
                                            self?.dismiss(animated: false){
                                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: EmailChangedSuccessfullyPopUpVC.getStoryboardID()) as! EmailChangedSuccessfullyPopUpVC
                                                vc.modalTransitionStyle = .crossDissolve
                                                vc.modalPresentationStyle = .overCurrentContext
                                                vc.callbackpopup = {
                                                    self?.dismiss(animated: false){
                                                        self?.navigationController?.popViewController(animated: true)
                                                        //                                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                                                        //                                                        self?.navigationController?.pushViewController(vc, animated: false)
                                                    }
                                                }
                                                self?.present(vc, animated: false)
                                            }
                                        }
                                        self?.present(vc, animated: false)
                                    }
                                }
                                self?.present(vc, animated: false)
                            }
                        }
                        self?.present(vc, animated: false)
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if Int.getInt(dictResult["status"]) == 401{
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
    
    //    Api State Type
    
    func getstateapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
    
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetstate, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        let state = kSharedInstance.getArray(withDictionary: dictResult["state"])
                        self.getstatelistarr = state.map{getstateModel(data: $0)}
                        
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
    
    //     Locality Api
    
    func getlocalityapi(id:Int){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let stateids = Int(self.stateid ?? 0) // For remove optional
        debugPrint("checkstateids",stateids)
        
        let params:[String : Any] = [
            "localitys_id":"\(String(describing: stateids))",
        ]
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kgetlocality, requestMethod: .POST,
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
                        let localitys = kSharedInstance.getArray(withDictionary: dictResult["localitys"])
                        self?.getlocalitylistarr = localitys.map{getlocalityModel(data: $0)}
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
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

// MARK: - DatePicker

extension EditProfileVC{
    func setupdate(){
        if #available(iOS 13.4, *) {
            timePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            timePicker.preferredDatePickerStyle = .wheels
        }
        self.timePicker.datePickerMode = .date
        timePicker.minuteInterval = 30
        //
        //        var components = Calendar.current.dateComponents([.hour, .minute, .month, .year, .day], from: timePicker.date)
        //        components.hour = 1
        //        components.minute = 30
        //        timePicker.setDate(Calendar.current.date(from: components)!, animated: true)
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 0
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        timePicker.maximumDate = maxDate
        timePicker.minimumDate = minDate
        self.textfieldDATE.inputView = self.timePicker
        self.textfieldDATE.inputAccessoryView = self.getToolBar()
        //       self.txtFieldDOB.inputView = self.getToolBar()
    }
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.textfieldDATE.text = dateFormatter.string(from: self.timePicker.date)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
}

// MARK: - Localisation

extension EditProfileVC{
    
    func setuplanguage(){
        lblEditProfile.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Edit profile", comment: "")
        lblPhone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number", comment: "")
        lblChangePhone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change", comment: "")
        lblEmailaddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email address", comment: "")
        lblChangeEmail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change", comment: "")
        lblFirstName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "First name", comment: "")
        lblLastName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last name", comment: "")
        lblDOB.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Date of birth", comment: "")
        lblheadingCountry.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Country", comment: "")
        lblState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "State", comment: "")
        lblLocality.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Locality", comment: "")
        lblGender.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select gender", comment: "")
        lblUserType.text  = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select user type*", comment: "")
        lblWhatsNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Whatsapp number", comment: "")
        btnSaveChanges.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Save changes", comment: ""), for: .normal)
    }
}

