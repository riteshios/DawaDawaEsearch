//
//  MoreVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 20/06/22.

import UIKit

class MoreVC: UIViewController {
    
//    MARK: - Properties
    
    @IBOutlet weak var ViewMain: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewSavedOpportunies: UIView!
    @IBOutlet weak var viewInterestedOpportunities: UIView!
    @IBOutlet weak var viewContactUs: UIView!
    @IBOutlet weak var viewLogOut: UIView!
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangePasword: UIButton!
    @IBOutlet weak var btnSavedOpportunities: UIButton!
    @IBOutlet weak var btnInterestedOpportunities: UIButton!
    
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var lblEditProfile: UILabel!
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblSavedOpportunity: UILabel!
    @IBOutlet weak var lblInterestedOpportunity: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    
    var callback:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setlanguage()
        self.setup()
    }
    
// MARK: - Life Cyclye
    

    func setup(){
        ViewMain.clipsToBounds = true
        ViewMain.layer.cornerRadius = 25
        ViewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        ViewMain.addShadowWithBlurOnView(ViewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
// MARK: - @IBAction
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.callback?("Dismiss")
    }
    @IBAction func btnSettingTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSetting.isSelected == true{
            self.viewSetting.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        self.callback?("Setting")
    }
    
    @IBAction func btnEditProfileTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEdit.isSelected == true{
            self.viewEditProfile.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        if UserData.shared.isskiplogin == true{
            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
        }
        else{
        self.callback?("EditProfile")
        }
    }
    
    @IBAction func btnChangePasswordTapped(_ sender: UIButton) {
//        self.callback4?("ChangePassword")
        sender.isSelected = !sender.isSelected
        if self.btnChangePasword.isSelected == true{
            self.viewChangePassword.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        if UserData.shared.isskiplogin == true{
            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
        }
        else{
        self.getoptapi()
        }
    }
    @IBAction func btnSavedOppTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSavedOpportunities.isSelected == true{
            self.viewSavedOpportunies.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        if UserData.shared.isskiplogin == true{
            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
        }
        else{
            self.callback?("SaveOpportunity")
        }
    }
    
    @IBAction func btnInterestedOppTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnInterestedOpportunities.isSelected == true{
            self.viewInterestedOpportunities.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        if UserData.shared.isskiplogin == true{
            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
        }
        else{
            self.callback?("InterestedOpportunities")
        }
    }
    
    @IBAction func btnContactUs(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnContactUs.isSelected == true{
            self.viewContactUs.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        self.callback?("ContactUs")
    }
    
    @IBAction func btnLogOutTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLogOut.isSelected == true{
            self.viewSetting.backgroundColor = UIColor.init(red: 255/255, green: 240/255, blue: 240/255, alpha : 1)
        }
//        if UserData.shared.isskiplogin == true{
//            self.showSimpleAlert(message: "First Create Account")
//        }
//        else{
        self.callback?("Logout")
//        }
    }
}

// MARK: - Api call

extension MoreVC{
    func getoptapi(){
        
        CommonUtils.showHud(show: true)
//        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
        let params:[String : Any] = [
            "email":UserData.shared.email
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
                        self?.callback?("ChangePassword")
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
}

extension MoreVC{
    func setlanguage(){
        lblSetting.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Settings", comment: "")
        lblEditProfile.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Edit Profile", comment: "")
        lblChangePassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Change password", comment: "")
        lblSavedOpportunity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Saved Opportunities", comment: "")
        lblInterestedOpportunity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Interested Opportunities", comment: "")
        lblContactUs.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Contact Us", comment: "")
        lblLogout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Log Out", comment: "")
    }
}


