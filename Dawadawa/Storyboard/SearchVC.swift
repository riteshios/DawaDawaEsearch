import UIKit

class SearchVC: UIViewController,UITextFieldDelegate,NewSocialPostCVCDelegate{
    //    MARK: - Properties -
    
    @IBOutlet weak var tblViewSearchOpp: UITableView!
    @IBOutlet weak var txtfieldSearch: UITextField!
    @IBOutlet weak var imgNotfound: UIImageView!
    @IBOutlet weak var viewSearch: UIView!
    
    var imgUrl = ""
    var docUrl = ""
    //    var userTimeLine = [SocialPostData]()
    var UserTimeLineOppdetails:SocialPostData?
    var img = [oppr_image]()
    var comment = [user_comment]()
    var txtcomment = " "
    
    lazy var globalApi = {
        GlobalApi()
    }()
    
    //    MARK: - UIView Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.imgNotfound.isHidden = true
        self.setup()
        viewSearch.addShadowWithBlurOnView(viewSearch, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgNotfound.isHidden = true
        self.txtfieldSearch.text = ""
    }
    
    override func viewWillLayoutSubviews() {
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            DispatchQueue.main.async {
                self.txtfieldSearch.semanticContentAttribute = .forceLeftToRight
                self.txtfieldSearch.textAlignment = .left
            }
            
        } else {
            DispatchQueue.main.async {
                self.txtfieldSearch.semanticContentAttribute = .forceRightToLeft
                self.txtfieldSearch.textAlignment = .right
            }
        }
    }
    
    func setup(){
        tblViewSearchOpp.register(UINib(nibName: "PopularSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PopularSearchTableViewCell")
        tblViewSearchOpp.register(UINib(nibName: "PremiumOppTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumOppTableViewCell")
        tblViewSearchOpp.register(UINib(nibName: "SocialPostTVC", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTVC")
        
        txtfieldSearch.delegate = self
        txtfieldSearch.returnKeyType = .search
    }
}
//    MARK: - UITableView Delegate and DataSource -

extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    
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
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PopularSearchTableViewCell") as! PopularSearchTableViewCell
            cell.SearchCollectionView.tag = indexPath.section
            return cell
            
        case 1:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PremiumOppTableViewCell") as! PremiumOppTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            cell.callbacknavigation = {
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
                            vc.camefrom = "search"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                        vc.camefrom = "search"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
            return cell
            
        case 2:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "SocialPostTVC") as! SocialPostTVC
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
            return 195
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
    //    MARK: - Protocol Delegate
    
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
            if UserData.shared.isskiplogin == true{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                }
                else{
                    self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                }
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
                                    self.tblViewSearchOpp.reloadData()
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
                                            self.tblViewSearchOpp.reloadData()
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
                        let oppid = Int.getInt(opppreid)
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
                            let oppid = Int.getInt(opppreid)
                            vc.oppid = oppid
                            
                            vc.callbackClosure = {
                                self.searchopportunityapi()
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
                            let userid = Int.getInt(opppreid)
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
                        let oppid = Int.getInt(opppreid)
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
    
    //    TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        txtfieldSearch.resignFirstResponder()
        if UserData.shared.isskiplogin == true{
            self.guestsearchopportunityapi()
        }
        else{
            self.searchopportunityapi()
        }
        return true
    }
}

//    MARK: - API Call -

extension SearchVC{
    // Search Api
    
    func searchopportunityapi(){
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
            "search":String.getString(self.txtfieldSearch.text),
            "user_id":Int.getInt(UserData.shared.id)
        ]
        debugPrint("user_id=-=-=-=",Int.getInt(UserData.shared.id))
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksearchopportunity, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(userTimeLine)")
                        
                        //          CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        DispatchQueue.main.async {
                            self?.tblViewSearchOpp.reloadData()
                        }
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //     CommonUtils.showToastForDefaultError()
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
                        //    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //      CommonUtils.showToastForDefaultError()
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
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    Guest Search api
    
    func guestsearchopportunityapi(){
        CommonUtils.showHud(show: true)
        
        let params:[String : Any] = [
            "search":String.getString(self.txtfieldSearch.text),
            "user_id":0
        ]
        
        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestsearchopportunity, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(userTimeLine)")
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //   CommonUtils.showToastForDefaultError()
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
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    else if Int.getInt(dictResult["status"]) == 400{
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
}

extension SearchVC{
    func setuplanguage(){
        txtfieldSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search opportunities", comment: "")
    }
}

