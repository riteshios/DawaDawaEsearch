//  ProfileVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 20/06/22.

import UIKit

class ProfileVC: UIViewController,NewSocialPostCVCDelegate{
    
    //    MARK: - Properties -
    
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewNoOpp: UIView!
    
    var oppid:Int?
    var imgUrl = ""
    var docUrl = ""
    var isProfileImageSelected = false
    var userImage:String?
    var datadashboard:data_dashboard?
    //    var userTimeLine = [SocialPostData]() //Array
    var UserTimeLineOppdetails:SocialPostData? // Dictionary m hai
    var comment = [user_comment]()
    var txtcomment = ""
    var isbtnAllSelect = false
    var isbtnPremiumSelect = false
    var isbtnFeaturedSelect = false
    
    lazy var globalApi = {
        GlobalApi()
    }()
    
    @IBOutlet weak var tblViewSocialPost: UITableView!
    
    //    MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTimeLine.removeAll()
        self.viewNoOpp.isHidden = true
        
        //        self.listoppoertunityapi()
        tblViewSocialPost.register(UINib(nibName: "OpportunitypostedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OpportunitypostedTableViewCell")
        tblViewSocialPost.register(UINib(nibName: "SocialPostTVC", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTVC")
        
        if UserData.shared.isskiplogin == true{
            print("Guest User")
            self.lblMobileNumber.isHidden = true
            self.lblEmail.isHidden = true
            self.viewNoOpp.isHidden = false
            userTimeLine.removeAll()
        }
        else{
            self.fetchdata()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.listoppoertunityapi()
        self.dashboardapi()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
    }
    
    func fetchdata(){
        self.lblFullName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        self.lblMobileNumber.text = UserData.shared.phone
        self.lblEmail.text = UserData.shared.email
        
        
        if let url = URL(string: "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
            debugPrint("urlimage...",  url)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    //                    self.ImageProfile.image = UIImage(data: data)
                    self.ImageProfile.sd_setImage(with: url, placeholderImage:UIImage(named: "Boss") )
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - @IBAction -
    
    @IBAction func btnEditImage(_ sender: UIButton) {
        if UserData.shared.isskiplogin == true{
            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
        }
        else{
            ImagePickerHelper.shared.showPickerController { image, url in
                self.isProfileImageSelected = true
                self.ImageProfile.image = image
                self.uploadImage(image: self.ImageProfile.image ?? UIImage())
            }
        }
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeScreenVC") as! WelcomeScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        
        if UserData.shared.isskiplogin == true{
            self.showAlert()
        }
        
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: MoreVC.getStoryboardID()) as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.callback = { txt in
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
                
                if txt == "SaveOpportunity"{
                    vc.dismiss(animated: false){
                        let vc = self.storyboard?.instantiateViewController(identifier: SavedOpportunitiesVC.getStoryboardID()) as! SavedOpportunitiesVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                if txt == "InterestedOpportunities"{
                    vc.dismiss(animated: false){
                        let vc = self.storyboard?.instantiateViewController(identifier: SavedOpportunitiesVC.getStoryboardID()) as! SavedOpportunitiesVC
                        self.navigationController?.pushViewController(vc, animated: true)
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
                            
                            if txt == "Logout"{
                                vc.dismiss(animated: false) {
                                    // self.logout()
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeScreenVC") as! WelcomeScreenVC
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
}
// MARK: - Table View -

extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewSocialPost.dequeueReusableCell(withIdentifier: "OpportunitypostedTableViewCell") as! OpportunitypostedTableViewCell
            
            if UserData.shared.isskiplogin == true{
                //                cell.imgOppPosted.isHidden = true
            }
            else{
                if UserData.shared.user_type == "0"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.expiry_date)
                    cell.lbltotalused.isHidden = true
                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                        cell.lblDate.text = "Expiration Date"
                        cell.lblPlan.text = "Subscription Plan"
                        cell.lblOpportunity.text = "Saved Opportunity"
                    }
                    else{
                        cell.lblDate.text = "تاريخ الإنتهاء"
                        cell.lblPlan.text = "خطة الاشتراك"
                        cell.lblOpportunity.text = "فرصة محفوظة"
                    }
                    
                    cell.lblshowplan.text = String.getString(self.datadashboard?.plan_type)
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_saved)
                    
                }
                else if UserData.shared.user_type == "1"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.total_create)
                    cell.lbltotalused.text = String.getString(self.datadashboard?.total_used) + "/"
                    debugPrint("cell.lbltotalused.text===",String.getString(self.datadashboard?.total_used))
                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                        cell.lblDate.text = "Total Create"
                        cell.lblPlan.text = "Total views"
                        cell.lblOpportunity.text = "Flagged Opportunities"
                    }
                    else{
                        cell.lblDate.text = "إجمالي الإنشاء"
                        cell.lblPlan.text = "عدد المشاهدات"
                        cell.lblOpportunity.text = "الفرص التي تم وضع علامة عليها"
                    }
                    cell.lblshowplan.text = String.getString(self.datadashboard?.no_view)
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_flag)
                }
                
                else if UserData.shared.user_type == "2"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.total_create)
                    cell.lbltotalused.text = String.getString(self.datadashboard?.total_used) + "/"
                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                        cell.lblDate.text = "Total Create"
                        cell.lblPlan.text = "Total views"
                        cell.lblOpportunity.text = "Flagged Opportunities"
                    }
                    else{
                        cell.lblDate.text = "إجمالي الإنشاء"
                        cell.lblPlan.text = "عدد المشاهدات"
                        cell.lblOpportunity.text = "الفرص التي تم وضع علامة عليها"
                    }
//                    cell.lbltotalused.isHidden = true
                    cell.lblshowplan.text = String.getString(self.datadashboard?.no_view)
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_flag)
                }
            }
            cell.callbackbtnSelect = { txt in
                if txt == "All"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        self.viewNoOpp.isHidden = false
                    }
                    else{
                        self.isbtnAllSelect  = true
                        self.listoppoertunityapi()
                    }
                }
                if txt == "Premium"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        self.viewNoOpp.isHidden = false
                    }
                    else{
                        self.isbtnPremiumSelect = true
                        self.getallpremiumapi()
                    }
                }
                if txt == "Featured"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        self.viewNoOpp.isHidden = false
                    }
                    else{
                       
                        self.isbtnFeaturedSelect = true
                        self.getallFeaturedapi()
                    }
                }
            }
            
            return cell
            
        case 1:
            
            let cell = self.tblViewSocialPost.dequeueReusableCell(withIdentifier: "SocialPostTVC") as! SocialPostTVC
            cell.SocialPostCV.tag = indexPath.section
            cell.celldelegate = self
            //            cell.HeightSocialPostCV.constant = cell.SocialPostCV.contentSize.height
            cell.SocialPostCV.reloadData()
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            if UserData.shared.isskiplogin == true{
                return 0
            }
            else{
                return 180
            }
            
        case 1:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
    }
    
    //    MARK: - Protocol Delegate -
    
    func SeeDetails(collectionviewcell: NewSocialPostCVC?, index: Int, didTappedInTableViewCell: SocialPostTVC) {
        
        if UserData.shared.isskiplogin == true{
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
            }
            else{
                self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
            }
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailScreenVC") as! DetailScreenVC
            vc.oppid = opppreid
            print("Tapped=-=-=")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func likecount(collectionviewcell: NewSocialPostCVC?, index: Int, didTappedintableviewcell: SocialPostTVC){
        if UserData.shared.isskiplogin == true{
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
            }
            else{
                self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
            }
        }
        else{
            if likeCount == "0"{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    self.showSimpleAlert(message: "0 Likes on this opportunity")
                }
                else{
                    self.showSimpleAlert(message: "0 معجب بهذه الفرصة")
                }
            }
            else{
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LikelistVC") as! LikelistVC
                
                if #available(iOS 15.0, *) {
                    if let presentationController = vc.presentationController as? UISheetPresentationController {
                        presentationController.detents = [.medium(), .large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                    }
                } else {
                    // Fallback on earlier versions
                }
                vc.oppr_id = opppreid
                vc.likecount = likeCount
                self.present(vc, animated: true)
            }
        }
    }
    func More(collectionviewcell: NewSocialPostCVC?, index: Int, didTappedintableviewcell: SocialPostTVC) {
        
        if UserData.shared.id == Int.getInt(user_id){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ProileSocialMoreVC.getStoryboardID()) as! ProileSocialMoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.callback = { txt in
                
                if txt == "Dismiss"{
                    self.dismiss(animated: true)
                    //   self.listoppoertunityapi()
                }
                
                if txt == "CopyLink"{
                    let share_link = String.getString(sharelink)
                    UIPasteboard.general.string = share_link
                    print("share_link\(share_link)")
//                    if kSharedUserDefaults.getlanguage() as? String == "en"{
//                        CommonUtils.showError(.info, String.getString("Link Copied"))
//                    }
//                    else{
//                        CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
//                    }
                }
                
                if txt == "Update"{
                    let oppid = Int.getInt(opppreid)
                    debugPrint("oppid+++++++",oppid)
                    self.opportunitydetailsapi(oppr_id: oppid)
                }
                if txt == "Delete"{
                    self.dismiss(animated: false){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: DeleteOpportunityPopUPVC.getStoryboardID()) as! DeleteOpportunityPopUPVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.callback = { txt in
                            
                            if txt == "Delete"{
                                vc.dismiss(animated: false) {
                                    let oppid = Int.getInt(opppreid)
                                    userTimeLine.remove(at: index)
                                    self.globalApi.deletepostoppoertunityapi(oppr_id: oppid)
                                    debugPrint("oppid......",oppid)
                                    self.tblViewSocialPost.reloadData()
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
                                    let oppid = Int.getInt(opppreid)
                                    self.globalApi.closeopportunityapi(opr_id: oppid ?? 0) { sucess in
                                        if sucess == 200 {
                                            
                                            statuscode = sucess
                                            print("\(statuscode)statuscodecloseopp=-=-=-")
                                            //                                            cell.lblcloseOpportunity.text = "Closed"
                                            //                                            cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
                                            self.tblViewSocialPost.reloadData()
                                        }
                                        
                                        else if sucess == 400{
                                            
                                        }
                                    }
                                    debugPrint("oppidclose......",oppid)
                                }
                            }
                        }
                        self.present(vc, animated: false)
                    }
                    
                }
                if txt == "ViewDetail"{
                    let oppid = Int.getInt(opppreid)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            self.present(vc, animated: false)
        }
    }
}

// MARK: -API call -

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
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    // Api Dashboard -
    
    func dashboardapi(){
        
        CommonUtils.showHudWithNoInteraction(show: true)
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
            "user_type":Int.getInt(String.getString(UserData.shared.user_type))
        ]
        
        debugPrint("usertype......",Int.getInt(String.getString(UserData.shared.user_type)))
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kdashboard, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                        
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        self?.datadashboard = data_dashboard(data: data)
                        
                        print("Datadashboard====-=\(self?.datadashboard)")
                        self?.tblViewSocialPost.reloadData()
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                        CommonUtils.showHudWithNoInteraction(show: false)
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //  CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    // Api All Opportunity
    
    func listoppoertunityapi(){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        
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
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.klistopportunity, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        
                        print("DataAllPost====-=\(userTimeLine)")
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblViewSocialPost.reloadData()
                        CommonUtils.showHudWithNoInteraction(show: false)
                        self?.viewNoOpp.isHidden = true
                       
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //       CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //     Api premium opportunity
    
    func getallpremiumapi(){
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
            "id":2
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
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        
                        print("DataAllPost====-=\(userTimeLine)")
                        
                        self?.tblViewSocialPost.reloadData()
                        self?.viewNoOpp.isHidden = true
                       
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //     Api Featured opportunity
    
    func getallFeaturedapi(){
        
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
            "id":3
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.klistopportunity, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
        
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
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        
                        print("DataAllPost====-=\(userTimeLine)")
                        
                        self?.tblViewSocialPost.reloadData()
                        self?.viewNoOpp.isHidden = true
                        
                    }
                    
                    else if Int.getInt(dictResult["status"]) == 400{
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    //    Api comment opportunity
    
    func commentoppoertunityapi(oppr_id:Int,completion: @escaping(_ viewH : [user_comment])->Void){
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
            "opr_id":oppr_id,
            "comment":String.getString(self.txtcomment)
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kaddcomment, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        
                        let comment = kSharedInstance.getArray(withDictionary: dictResult["user_comment"])
                        debugPrint("Commentdata=-=-=1-=",comment)
                        self?.comment = comment.map{user_comment(data: kSharedInstance.getDictionary($0))}
                        debugPrint("Commentdata=-=-=0-=", self?.comment[0].comments)
                        completion(self!.comment)
                        debugPrint("CommentData=-=-=0-=",completion(self!.comment))
                        
                        CommonUtils.showError(.info, String.getString(dictResult["Opportunity"]))
                        
                    }
                    
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
    
    //    Opportunity Details api
    
    func opportunitydetailsapi(oppr_id:Int){
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
            "oppr_id":oppr_id,
            "user_id":UserData.shared.id
        ]
        
        debugPrint("oppr_id...===...",oppr_id)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kopportunitydetails, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        
                        self?.imgUrl = String.getString(dictResult["opr_images"])
                        self?.docUrl = String.getString(dictResult["opr_documents"])
                        let opportunity = kSharedInstance.getDictionary(dictResult["Opportunity"])
                        self?.UserTimeLineOppdetails = SocialPostData(data: opportunity)
                        
                        debugPrint("OpportunityDetails=-=-===",self?.UserTimeLineOppdetails)
                        
                        if Int.getInt(self?.UserTimeLineOppdetails?.category_id) == 1{
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: RockPitOpportunityVC.getStoryboardID()) as! RockPitOpportunityVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.userTimeLineoppdetails = self?.UserTimeLineOppdetails
                            vc.isedit = "True"
                            vc.imgUrl = self!.imgUrl
                            vc.docUrl = self!.docUrl
                            vc.oppid = oppr_id
                            debugPrint("oppid=-=-=-==-=", vc.oppid)
                            vc.imgarray  = self?.UserTimeLineOppdetails?.oppimage ?? []
                            vc.docarray = self?.UserTimeLineOppdetails?.oppdocument ?? []
                            debugPrint("imgaraay=-=-=-==-=", vc.imgarray)
                            
                            
                        }
                        else if Int.getInt(self?.UserTimeLineOppdetails?.category_id) == 2{
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: TrailingOpportunityVC.getStoryboardID()) as! TrailingOpportunityVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.userTimeLineoppdetails = self?.UserTimeLineOppdetails
                            vc.isedit = "True"
                            vc.imgUrl = self!.imgUrl
                            vc.docUrl = self!.docUrl
                            vc.oppid = oppr_id
                            debugPrint("oppid=-=-=-==-=", vc.oppid)
                            vc.imgarray  = self?.UserTimeLineOppdetails?.oppimage ?? []
                            vc.docarray = self?.UserTimeLineOppdetails?.oppdocument ?? []
                            debugPrint("imgaraay=-=-=-==-=", vc.imgarray)
                            
                        }
                        
                        else if Int.getInt(self?.UserTimeLineOppdetails?.category_id) == 3{
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: MiningBusinessVC.getStoryboardID()) as! MiningBusinessVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.userTimeLineoppdetails = self?.UserTimeLineOppdetails
                            vc.isedit = "True"
                            vc.imgUrl = self!.imgUrl
                            vc.docUrl = self!.docUrl
                            vc.oppid = oppr_id
                            debugPrint("oppid=-=-=-==-=", vc.oppid)
                            vc.imgarray  = self?.UserTimeLineOppdetails?.oppimage ?? []
                            vc.docarray = self?.UserTimeLineOppdetails?.oppdocument ?? []
                            debugPrint("imgaraay=-=-=-==-=", vc.imgarray)
                        }
                        else if Int.getInt(self?.UserTimeLineOppdetails?.category_id) == 4{
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: MiningServiceVC.getStoryboardID()) as! MiningServiceVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.userTimeLineoppdetails = self?.UserTimeLineOppdetails
                            vc.isedit = "True"
                            vc.imgUrl = self!.imgUrl
                            vc.docUrl = self!.docUrl
                            vc.oppid = oppr_id
                            debugPrint("oppid=-=-=-==-=", vc.oppid)
                            vc.imgarray  = self?.UserTimeLineOppdetails?.oppimage ?? []
                            vc.docarray = self?.UserTimeLineOppdetails?.oppdocument ?? []
                            debugPrint("imgaraay=-=-=-==-=", vc.imgarray)
                        }
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
                //                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
}


