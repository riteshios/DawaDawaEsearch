//
//  ProfileVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    var imgUrl = ""
    var isProfileImageSelected = false
    var userImage:String?
    var userTimeLine = [SocialPostData]()
    
    @IBOutlet weak var tblViewSocialPost: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listoppoertunityapi()
        tblViewSocialPost.register(UINib(nibName: "OpportunitypostedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OpportunitypostedTableViewCell")
        tblViewSocialPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        
        
        
        
        if UserData.shared.isskiplogin == true{
            print("hghjj")
            //            self.lblFullName.text = "XYZ"
            //            self.lblMobileNumber.text = "exnsds"
        }
        else{
            self.fetchdata()
        }
    }
    
    func fetchdata(){
        self.lblFullName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        self.lblMobileNumber.text = UserData.shared.phone
        self.lblEmail.text = UserData.shared.email
        
        
        if let url = URL(string: "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
            debugPrint("url...",  url)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.ImageProfile.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
        
    }
    
    // MARK: - @IBAction
    
    @IBAction func btnEditImage(_ sender: UIButton) {
        ImagePickerHelper.shared.showPickerController { image, url in
            self.isProfileImageSelected = true
            self.ImageProfile.image = image
            self.uploadImage(image: self.ImageProfile.image ?? UIImage())
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
    }
    
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MoreVC.getStoryboardID()) as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback4 = { txt in
            if txt == "Dismiss"{
                vc.dismiss(animated: false){
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            if txt == "Setting"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(identifier: SettingVC.getStoryboardID()) as! SettingVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if txt == "EditProfile"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(identifier: EditProfileVC.getStoryboardID()) as! EditProfileVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if txt == "ChangePassword"{
                self.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordOTPVerifyVC.getStoryboardID()) as! ChangePasswordOTPVerifyVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callbackotp = {
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordVC.getStoryboardID()) as! ChangePasswordVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.callbackchangepassword = {
                                self.dismiss(animated: false){
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: PasswordChangedSuccessfullyPopUpVC.getStoryboardID()) as! PasswordChangedSuccessfullyPopUpVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overCurrentContext
                                    vc.callbackpopuop = {
                                        self.dismiss(animated: false){
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier:ProfileVC.getStoryboardID()) as! ProfileVC
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
            if txt == "ContactUs"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(identifier: ContactUsVC.getStoryboardID()) as! ContactUsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if txt == "Logout"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: LogOutVC.getStoryboardID()) as! LogOutVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callbacklogout = { txt in
                        //                        if txt == "Cancel"{
                        //                            vc.dismiss(animated: false){
                        //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                        //                                self.navigationController?.pushViewController(vc, animated: false)
                        //                            }
                        //                        }
                        //
                        if txt == "Logout"{
                            vc.dismiss(animated: false) {
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                    }
                    self.present(vc, animated: false)
                }
            }
        }
        self.present(vc, animated: false)
    }
}
// MARK: - Table View

extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return userTimeLine.count
            
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewSocialPost.dequeueReusableCell(withIdentifier: "OpportunitypostedTableViewCell") as! OpportunitypostedTableViewCell
            return cell
            
        case 1:
            let cell = self.tblViewSocialPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            cell.SocialPostCollectionView.tag = indexPath.section
            
            let profilrimageurl = "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"
            
            let obj = userTimeLine[indexPath.row]
            cell.lblUserName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.Imageuser.downlodeImage(serviceurl: profilrimageurl, placeHolder: UIImage(named: "Boss"))
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            cell.callbackmore = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ProileSocialMoreVC.getStoryboardID()) as! ProileSocialMoreVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callback = { txt in
                    
                    if txt == "Delete"{
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: DeleteOpportunityPopUPVC.getStoryboardID()) as! DeleteOpportunityPopUPVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.callback = { txt in
                                
                                if txt == "Delete"{
                                    vc.dismiss(animated: false) {
                                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                        self.userTimeLine.remove(at: indexPath.row)
                                        self.deletepostoppoertunityapi(oppr_id: oppid)
                                        debugPrint("oppid......",oppid)
                    
//                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                            }
                            self.present(vc, animated: false)
                        }
                        
                    }
                    
                    if txt == "Close"{
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ClosePopUpVC.getStoryboardID()) as! ClosePopUpVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.callback = { txt in
                                
                                if txt == "Close"{
                                    vc.dismiss(animated: false) {
                                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                        self.closeopportunityapi(opr_id: oppid)
                                        debugPrint("oppid......",oppid)

//                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                            }
                            self.present(vc, animated: false)
                        }
                        
                    }
                    
                    
                }
                self.present(vc, animated: false)
            }
            return cell
            
            
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 150
            
        case 1:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
        
    }
    
}

// MARK: -API call

extension ProfileVC{
    
    //    Api upload image
    
    func uploadImage(image:UIImage?){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
            //            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        let params:[String : Any] = [
            "user_id":UserData.shared.id
        ]
        
        let uploadimage:[String:Any] = ["profile_image":self.ImageProfile.image ?? UIImage()]
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName:ServiceName.keditprofileimage , requestMethod: .post, requestImages: [uploadimage], requestVideos: [:], requestData:params, req : self.ImageProfile.image! )
        { (result:Any?, error:Error?, errortype:ErrorType?, statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errortype == .requestSuccess {
                debugPrint("result=====",result)
                let dictResult = kSharedInstance.getDictionary(result)
                debugPrint("dictResult====",dictResult)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        let data =  kSharedInstance.getDictionary(dictResult["data"])
                        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                        UserData.shared.saveData(data:data, token: String.getString(kSharedUserDefaults.getLoggedInAccessToken()))
                        
                        let obj = kSharedInstance.getDictionary(data["social_profile"])
                        self.userImage = String.getString(obj.first)
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errortype == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    // Api show post
    
    
    func listoppoertunityapi(){
        
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        let params:[String : Any] = [
            "user_id":Int.getInt(UserData.shared.id),
            "id":1
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.klistopportunity, requestMethod: .POST,
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
                        self?.imgUrl = String.getString(dictResult["opr_base_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        
                        print("-=-=--=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblViewSocialPost.reloadData()
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
//    Delete Post Opportunity Api
    func deletepostoppoertunityapi(oppr_id:Int){
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        let params:[String : Any] = [
            "user_id":Int.getInt(UserData.shared.id),
            "oppr_id":oppr_id
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kdeleteopportunity, requestMethod: .POST,
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
                      
                        

                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblViewSocialPost.reloadData()
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
//    Close opportunity api
    
    
    func closeopportunityapi(opr_id:Int){
        
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        let params:[String : Any] = [
            "user_id":Int.getInt(UserData.shared.id),
            "id":opr_id
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kcloseopportunity, requestMethod: .POST,
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
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 404{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, "Opportunity has been closed")
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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

