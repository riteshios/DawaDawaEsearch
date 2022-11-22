//  UserProfileDetailsVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/09/22.

import UIKit
import Cosmos

class UserProfileDetailsVC: UIViewController {
    
    @IBOutlet weak var ImgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblmail: UILabel!
    @IBOutlet weak var viewRating:CosmosView!
    
    @IBOutlet weak var ViewRateUser: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAboutDescription: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblUserProfile: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var btnRateUser: UIButton!
    
    var userid = 0
    var userdata:user_Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRating.settings.starSize = 27
        viewRating.settings.starMargin = 4
        viewRating.settings.fillMode = .half
        viewRating?.didTouchCosmos = .none
        viewRating?.didFinishTouchingCosmos = .none
        self.setuplanguage()
        
        if UserData.shared.id == self.userid{
            self.ViewRateUser.isHidden = true
        }
        else{
            self.ViewRateUser.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getuserdatapi()
    }
    
    func fetdata(){
        self.lblName.text = String.getString(self.userdata?.name)
        self.lblMobile.text = String.getString(self.userdata?.phone)
        self.lblmail.text = String.getString(self.userdata?.email)
        self.lblRating.text = String.getString(self.userdata?.rating)
        self.lblUserName.text = String.getString(self.userdata?.name)
        self.lblAboutDescription.text = String.getString(self.userdata?.about)
        let newRatingValue = Double.getDouble(userdata?.rating)
        self.viewRating.rating = newRatingValue
        self.lblRating.text = String.getString(newRatingValue)
        
        if let url = URL(string: String.getString(self.userdata?.image)){
            debugPrint("url...",  url)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.ImgUser.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
    }
    //  MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnRateUserTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: RateUserPopUpVC.getStoryboardID()) as! RateUserPopUpVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.rateuserid = self.userid
        vc.callbackClosure = {
            self.getuserdatapi()
        }
        
        self.present(vc, animated: false)
    }
}

//    MARK: - API Call
extension UserProfileDetailsVC{
    
    //    user data api
    
    func getuserdatapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: "api/userData/\(self.userid)", requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["responsecode"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        self.userdata = user_Data(data: data)
                        print("DataAllUserdetails===\(self.userdata)")
                        self.fetdata()
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
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
}

extension UserProfileDetailsVC {
    func setuplanguage(){
        lblUserProfile.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "User Profile", comment: "")
        lblAbout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "About", comment: "")
        btnRateUser.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate user", comment: ""), for: .normal)
    }
}
