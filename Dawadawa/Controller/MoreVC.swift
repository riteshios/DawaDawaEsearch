//
//  MoreVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit

class MoreVC: UIViewController {
    
//    MARK: - Properties
    
    @IBOutlet weak var ViewMain: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewSavedOpportunies: UIView!
    @IBOutlet weak var viewContactUs: UIView!
    @IBOutlet weak var viewLogOut: UIView!
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangePasword: UIButton!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    
    
    var callback4:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.callback4?("Dismiss")
    }
    @IBAction func btnSettingTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSetting.isSelected == true{
            self.viewSetting.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        self.callback4?("Setting")
    }
    
    @IBAction func btnEditProfileTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEdit.isSelected == true{
            self.viewEditProfile.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        
        self.callback4?("EditProfile")
    }
    
    @IBAction func btnChangePasswordTapped(_ sender: UIButton) {
//        self.callback4?("ChangePassword")
        sender.isSelected = !sender.isSelected
        if self.btnChangePasword.isSelected == true{
            self.viewChangePassword.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        self.getoptapi()
    }
    
    @IBAction func btnContactUs(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnContactUs.isSelected == true{
            self.viewContactUs.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 253/255, alpha: 1)
        }
        self.callback4?("ContactUs")
    }
    
    @IBAction func btnLogOutTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLogOut.isSelected == true{
            self.viewSetting.backgroundColor = UIColor.init(red: 255/255, green: 240/255, blue: 240/255, alpha : 1)
        }
        self.callback4?("Logout")
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
                        self?.callback4?("ChangePassword")
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


