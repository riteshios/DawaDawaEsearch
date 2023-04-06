//  HomeVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 20/07/22.

import UIKit
import STTabbar
import IQKeyboardManagerSwift

class HomeVC: UIViewController,UITabBarControllerDelegate,PremiumOppCollectionViewCellDelegate,NewSocialPostCVCDelegate{
    
    //    MARK: - Properties -
    @IBOutlet weak var tblViewViewPost: UITableView!
    
    
    var docUrl = ""
    var count = ""
    var statuslike:Int?
    // var userTimeLine = [SocialPostData]()
    var UserTimeLineOppdetails:SocialPostData?
    var userdetail = [user_detail]()
    var comment = [user_comment]()
    var txtcomment = " "
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnSearchOpportunity: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ImgUser: UIImageView!
    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblCountNotification: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    
    lazy var globalApi = {
        GlobalApi()
    }()
    
    //    MARK: - UIView Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        self.setuplanguage()
        //  self.imgNotification.isHidden = true
        debugPrint("nameid",UserData.shared.id)
        debugPrint("nameid",UserData.shared.name)
        if UserData.shared.isskiplogin == true{
            print("Guest User=-=-")
            self.tblViewViewPost.reloadData()
            if cameFrom != "FilterData"{
                self.guestgetallopportunity()
                print("Guest User Filte=-=-=")
            }
        }
        else{
            self.fetchdata()
        }
        self.setup()
        viewSearch.addShadowWithBlurOnView(viewSearch, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cameFrom != "FilterData"{
            self.getallopportunity()
            self.fetchdata()
            self.getcountnotification()
            //            self.scrollToTop()
        }
        
        if UserData.shared.isskiplogin == true{
            if cameFrom != "FilterData"{
                self.guestgetallopportunity()
                //            self.scrollToTop()
            }
        }
    }
    
    //    override func viewWillLayoutSubviews() {
    //        let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
    //        if kSharedUserDefaults.getlanguage() as? String == "en"{
    //            DispatchQueue.main.async {
    //                cell.txtviewComment.semanticContentAttribute = .forceLeftToRight
    //                cell.txtviewComment.textAlignment = .left
    //            }
    //
    //        } else {
    //            DispatchQueue.main.async {
    //                cell.txtviewComment.semanticContentAttribute = .forceRightToLeft
    //                cell.txtviewComment.textAlignment = .right
    //            }
    //        }
    //    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //            let tabBarIndex = tabBarController.selectedIndex
        if tabBarController.selectedIndex == 0 {
            print("home tapped")
            self.scrollToTop()
        }
    }
    
    private func setup(){
        tblViewViewPost.register(UINib(nibName: "ViewPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ViewPostTableViewCell")
        tblViewViewPost.register(UINib(nibName: "FilterTVCell", bundle: Bundle.main), forCellReuseIdentifier: "FilterTVCell")
        tblViewViewPost.register(UINib(nibName: "SocialPostTVC", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTVC")
    }
    
    func fetchdata(){
        
        self.lblUserName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        if let url = URL(string: "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
            debugPrint("url...",  url)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    //                    self.ImgUser.image = UIImage(data: data)
                    //                    let userUrl = URL(string: url)
                    self.ImgUser.sd_setImage(with: url, placeholderImage:UIImage(named: "Boss") )
                }
            }
            task.resume()
        }
    }
    //        override func viewDidAppear(_ animated: Bool) {
    //            super.viewDidAppear(animated)
    //            self.tabBarController?.tabBar.isHidden = false
    //            self.tabBarController?.tabBar.layer.zPosition = 0
    //        }
    //    MARK: - @IBACtion and Methods -
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        if UserData.shared.isskiplogin == true{
            self.showAlert()
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//    MARK: - Table View -
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            //            return userTimeLine.count
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "FilterTVCell") as! FilterTVCell
            cell.textArray = filteredArray
            cell.buttonFilter.addTarget(self, action: #selector(buttonTappedFilter), for: .touchUpInside)
            cell.buttonClear.addTarget(self, action: #selector(buttonTappedClear), for: .touchUpInside)
            return cell
            
        case 1:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
            
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            cell.celldelegate = self
            
            if UserData.shared.isskiplogin == true{
                if cameFrom != "FilterData"{
                    // cell.heightMainView.constant = 100
                    cell.heightViewCollectionview.constant = 50
                    // cell.heightCollectionView.constant = 0
                }
            }else{
                cell.callbacknavigation = { txt in
                    if txt == "ViewAll"{
                        if UserData.shared.isskiplogin == true{
                            if kSharedUserDefaults.getlanguage() as? String == "en"{
                                self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                            }
                            else{
                                self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                            }
                        }
                        else{
                            
                            if UserData.shared.user_type == "0"{// Investor
                                if kSharedUserDefaults.getpayment_type() as? String == "Basic Plan"{
                                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                                        self.showSimpleAlert(message: "Please Upgrade the Plan for Premium and Featured Opportunities")
                                    }
                                    else{
                                        self.showSimpleAlert(message: "يرجى ترقية خطة الفرص المميزة والمميزة")
                                    }
                                }
                                else{
                                    let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                                    vc.camefrom = "home"
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else{
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                                vc.camefrom = "home"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                    
                    if txt == "Filter"{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: FilterVC.getStoryboardID()) as! FilterVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
            return cell
            
        case 2:
            
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "SocialPostTVC") as! SocialPostTVC
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
            return 70
            
        case 1:
            if UserData.shared.isskiplogin == true{
                return 90
            }
            else{
                return 300
            }
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    //    MARK: - Protocol Delegate Method
    
    func collectionView(collectionviewcell: PremiumOppCollectionViewCell?, index: Int, didTappedInTableViewCell: ViewPostTableViewCell) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailScreenVC") as! DetailScreenVC
        vc.oppid = opppreid
        print("Tappedpremium=-=-=")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        
                    }
                    else{
                        let share_link = String.getString(sharelink)
                        UIPasteboard.general.string = share_link
                        print("share_link\(share_link)")
//                        if kSharedUserDefaults.getlanguage() as? String == "en"{
//                            CommonUtils.showError(.info, String.getString("Link Copied"))
//                        }
//                        else{
//                            CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
//                        }
                    }
                    
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
                                    self.tblViewViewPost.reloadData()
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
                                            self.tblViewViewPost.reloadData()
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
        
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.callback = { txt in
                
                if txt == "Chatwithuser"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        
                    }
                    else{
                        let userid = Int.getInt(opppreid)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                        vc.friendid = userid
                        vc.friendname = frnd_name
                        vc.friendimage = imguser_url
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.dismiss(animated: true)
                    }
                }
                if txt == "CopyLink"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                        
                    }
                    else{
                        let share_link = String.getString(sharelink)
                        UIPasteboard.general.string = share_link
                        print("share_link\(share_link)")
//                        if kSharedUserDefaults.getlanguage() as? String == "en"{
//                            CommonUtils.showError(.info, String.getString("Link Copied"))
//                        }
//                        else{
//                            CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
//                        }
                    }
                }
                
                if txt == "MarkasInterested"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                    }
                    else{
                        let oppid = Int.getInt(user_id)
                        self.markinterestedapi(oppr_id: oppid)
                        self.dismiss(animated: true)
                    }
                }
                
                if txt == "Flag"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                    }
                    else{
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: FlagPostPopUPVC.getStoryboardID()) as! FlagPostPopUPVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            let oppid = Int.getInt(user_id)
                            vc.oppid = oppid
                            
                            vc.callbackClosure = {
                                self.getallopportunity()
                            }
                            self.present(vc, animated: false)
                            
                            // cell.imgOppFlag.isHidden = false
                        }
                    }
                }
                
                if txt == "Report"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                    }
                    else{
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ReportUserPopUpVC.getStoryboardID()) as! ReportUserPopUpVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            let userid = Int.getInt(user_id)
                            vc.userid = userid
                            self.present(vc, animated: false)
                        }
                    }
                }
                
                if txt == "viewdetails"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                    }
                    else{
                        let oppid = Int.getInt(user_id)
                        debugPrint("detailsppid=-=-=",oppid)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                        
                        vc.oppid = oppid
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            self.present(vc, animated: false)
        }
    }
    
    private func scrollToTop() { // Scroll table view to Top
        let topRow = IndexPath(row: 0,section: 0)
        self.tblViewViewPost.scrollToRow(at: topRow,at: .bottom, animated: true ) // .top krne pr cell tk scroll krega or .bottom krne pr header tk scroll krega
        if UserData.shared.isskiplogin == true{
            self.guestgetallopportunity()
        }
        else{
            self.getallopportunity()
        }
        
    }
    
    @objc func buttonTappedFilter(_ sender:UIButton){
                let vc = self.storyboard!.instantiateViewController(withIdentifier: FilterVC.getStoryboardID()) as! FilterVC
                filteredArray.removeAll()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        
    @objc func buttonTappedClear(_ sender:UIButton){
              filteredArray.removeAll()
        if UserData.shared.isskiplogin == true{
            self.guestgetallopportunity()
        }
        else{
            self.getallopportunity()
        }
             
         }
}
//    MARK: - Api Call -

extension HomeVC{
    // Api all opportunity
    func getallopportunity(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let url =  ServiceName.kgetallopportunity + "\(UserData.shared.id)"
        debugPrint("urlallopportunity==",url)
        
        //passing userid in api url
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: url, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("Dataallpost=\(userTimeLine)")
                        
                        self.tblViewViewPost.reloadData()
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //        CommonUtils.showToastForDefaultError()
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
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //    CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    Markinterestedapi
    
    func markinterestedapi(oppr_id:Int){
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
            "opr_id":oppr_id
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kmarkinterested, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                    
                    else if  Int.getInt(dictResult["status"]) == 201{
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //    CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    Guest getallopportunity
    func guestgetallopportunity(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kguestgetallopportunity, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("Dataallpost=\(userTimeLine)")
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.tblViewViewPost.reloadData()
                        self.lblUserName.text = String.getString("Guest User")
                        debugPrint("self.lblUserName.text===",self.lblUserName.text)
                        self.ImgUser.image = UIImage(named: "Boss")
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //        CommonUtils.showToastForDefaultError()
            }
        }
        
    }
    
    //    Api Detail Opportunity
    
    func getalldetail(oppr_id:Int){
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
                        
                        imgUrl = String.getString(dictResult["opr_base_url"])
                        
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataAllPremiumPost===\(userTimeLine)")
                        
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
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
                        
                        imgUrl = String.getString(dictResult["opr_images"])
                        self?.docUrl = String.getString(dictResult["opr_documents"])
                        let opportunity = kSharedInstance.getDictionary(dictResult["Opportunity"])
                        self?.UserTimeLineOppdetails = SocialPostData(data: opportunity)
                        
                        debugPrint("OpportunityDetails=-=-===",self?.UserTimeLineOppdetails)
                        
                        if Int.getInt(self?.UserTimeLineOppdetails?.category_id) == 1{
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: RockPitOpportunityVC.getStoryboardID()) as! RockPitOpportunityVC
                            self?.navigationController?.pushViewController(vc, animated: true)
                            vc.userTimeLineoppdetails = self?.UserTimeLineOppdetails
                            vc.isedit = "True"
                            vc.imgUrl = imgUrl
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
                            vc.imgUrl = imgUrl
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
                            vc.imgUrl = imgUrl
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
                            vc.imgUrl = imgUrl
                            vc.docUrl = self!.docUrl
                            vc.oppid = oppr_id
                            debugPrint("oppid=-=-=-==-=", vc.oppid)
                            vc.imgarray  = self?.UserTimeLineOppdetails?.oppimage ?? []
                            vc.docarray = self?.UserTimeLineOppdetails?.oppdocument ?? []
                            debugPrint("imgaraay=-=-=-==-=", vc.imgarray)
                            
                        }
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    //    Api count Notification
    
    func getcountnotification(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        //passing userid in api url
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kcountNotification, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        let count = String.getString(dictResult["count"])
                        print("count=-==\(count)")
                        
                        self.lblCountNotification.text = count
                        //  self.imgNotification.isHidden = false
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        // self.imgNotification.isHidden = false
                        // self.imgNotification.image = UIImage(named: "notification-bing-1")
                    }
                    
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //       CommonUtils.showToastForDefaultError()
            }
        }
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
// MARK: - Localisation

extension HomeVC{
    func setuplanguage(){
        lblHello.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Hello,", comment: "")
        btnSearchOpportunity.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search Opportunities", comment: ""), for: .normal)
    }
}
