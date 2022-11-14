//
//  HomeVC.swift
//  Dawadawa

//  Created by Ritesh Gupta on 20/07/22.


import UIKit
import STTabbar
import IQKeyboardManagerSwift

class HomeVC: UIViewController{
    
    
    @IBOutlet weak var tblViewViewPost: UITableView!
    
    var imgUrl = ""
    var docUrl = ""
    var count = ""
    var statuslike:Int?
    // var userTimeLine = [SocialPostData]()
    var UserTimeLineOppdetails:SocialPostData?
    var userdetail = [user_detail]()
    var comment = [user_comment]()
    var txtcomment = " "
    
    @IBOutlet weak var viewSearch: UIView!
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ImgUser: UIImageView!
    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblCountNotification: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.imgNotification.isHidden = true
        debugPrint("nameid",UserData.shared.id)
        debugPrint("nameid",UserData.shared.name)
        if UserData.shared.isskiplogin == true{
            print("Guest User")
            if cameFrom != "FilterData"{
                self.guestgetallopportunity()
                
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
        }
    }
    
    private func setup(){
        tblViewViewPost.register(UINib(nibName: "ViewPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ViewPostTableViewCell")
        tblViewViewPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
    }
    
    func fetchdata(){
        
        self.lblUserName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        if let url = URL(string: "\("https://demo4esl.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
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
    
    //
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        self.tabBarController?.tabBar.isHidden = false
    //        self.tabBarController?.tabBar.layer.zPosition = 0
    //    }
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 1
        
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
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
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
            
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            
            if UserData.shared.isskiplogin == true{
                if cameFrom != "FilterData"{
                    //                    cell.heightMainView.constant = 100
                    cell.heightViewCollectionview.constant = 50
                    cell.heightCollectionView.constant = 0
                }
            }else{
                cell.callbacknavigation = { txt in
                    if txt == "ViewAll"{
                        if UserData.shared.isskiplogin == true{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                            vc.camefrom = "home"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                    if txt == "Filter"{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: FilterVC.getStoryboardID()) as! FilterVC
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                    }
                }
            }
            
            
            return cell
            
        case 1:
            
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]
            
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            debugPrint("username.....", cell.lblUserName.text)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.lblRating.text = String.getString(obj.opr_rating)
            
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            let imguserurl = String.getString(obj.userdetail?.social_profile)
            //            debugPrint("socialprofile......",imguserurl)
            //            cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
            
            let userUrl = URL(string: imguserurl)
            cell.Imageuser.sd_setImage(with: userUrl, placeholderImage:UIImage(named: "Boss") )
            
            
            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "Likes"
            
            cell.imgOpp_plan.image = obj.opp_plan == "Featured" ? UIImage(named: "Star Filled") : obj.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "Folded Booklet")
            
            
            if Int.getInt(obj.close_opr) == 0{
                cell.lblTitle.text = String.getString(obj.title)
                cell.lblTitle.textColor = .black
            }
            else{
                cell.imgredCircle.isHidden = false
                cell.lblcloseOpportunity.isHidden = false
            }
            
            
            if String.getString(obj.is_user_like) == "1"{
                cell.imglike.image = UIImage(named: "dil")
                cell.lbllike.text = "Liked"
                
            }
            else{
                cell.imglike.image = UIImage(named: "unlike")
                cell.lbllike.text = "Like"
            }
            
            if String.getString(obj.is_saved) == "1"{
                cell.imgsave.image = UIImage(named: "saveopr")
                cell.lblSave.text = "Saved"
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                cell.lblSave.text = "Save"
            }
            
            if String.getString(obj.is_flag) == "1"{
                cell.imgOppFlag.isHidden = false
            }
            else{
                cell.imgOppFlag.isHidden = true
            }
            
            if obj.oppimage.count == 0{
                cell.heightSocialPostCollectionView.constant = 0
            }
            else{
                cell.heightSocialPostCollectionView.constant = 225
            }
            
            if String.getString(obj.opr_rating) == ""{
                cell.WidthViewRating.constant = 35
                cell.lblRating.isHidden = true
            }
            else{
                cell.WidthViewRating.constant = 58
                cell.lblRating.isHidden = false
            }
            
            if UserData.shared.id == Int.getInt(obj.user_id){
                cell.btnChat.isHidden = true
            }
            else{
                cell.btnChat.isHidden = false
            }
            cell.callback = { txt, sender in
                
                if txt == "Chat"{
                    
                    let userid = Int.getInt(userTimeLine[indexPath.row].user_id)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                    vc.friendid = userid
                    vc.friendname = String.getString(obj.userdetail?.name)
                    vc.friendimage = imguserurl
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Profileimage"{
                    let user_id = userTimeLine[indexPath.row].user_id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = user_id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                if txt == "Like"{
                    if cell.btnlike.isSelected == true{
                        if UserData.shared.isskiplogin == true{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            let oppid = userTimeLine[indexPath.row].id
                            debugPrint("oppid--=-=-=-",oppid)
                            
                            self.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike in
                                obj.likes = Int.getInt(countLike)
                                cell.lblLikeCount.text = String.getString(obj.likes) + " " + "Likes"
                            }
                            cell.imglike.image = UIImage(named: "dil")
                            cell.lbllike.text = "Liked"
                            
                            debugPrint("count=-==0-",self.count)
                            //   self.getallopportunity()
                            
                        }
                    }
                }
                
                if txt == "Share"{
                    
                    let image = obj.share_link
                    
                    let imageShare = [ image! ]
                    let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
                
                if txt == "Rate"{
                    let oppid = userTimeLine[indexPath.row].id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: RateOpportunityPopUPVC.getStoryboardID()) as! RateOpportunityPopUPVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.oppid = oppid ?? 0
                    
                    vc.callbackClosure = {
                        self.getallopportunity()
                    }
                    self.present(vc, animated: false)
                    
                }
                
                if txt == "Save"{
                    if sender.isSelected{
                        
                        if String.getString(obj.is_saved) == "0"{
                            let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                            debugPrint("saveoppid=-=-=",oppid)
                            self.saveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "saveopr")
                            cell.lblSave.text = "Saved"
                        }
                        else{
                            let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                            self.unsaveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "save-3")
                            cell.lblSave.text = "Save"
                        }
                        
                    }
                    else{
                        let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                        self.unsaveoppoertunityapi(oppr_id: oppid)
                        cell.imgsave.image = UIImage(named: "save-3")
                        cell.lblSave.text = "Save"
                    }
                }
                
                if txt == "More" {
                    
                    if UserData.shared.id == Int.getInt(obj.user_id){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreSelfVC.getStoryboardID()) as! HomeSocialMoreSelfVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.callback = { txt in
                            
                            if txt == "Update"{
                                if UserData.shared.isskiplogin == true{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                    debugPrint("oppid+++++++",oppid)
                                    self.opportunitydetailsapi(oppr_id: oppid)
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
                                                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                                self.closeopportunityapi(opr_id: oppid)
                                                debugPrint("oppidclose......",oppid)
                                                self.getallopportunity()
                                            }
                                        }
                                    }
                                    self.present(vc, animated: false)
                                }
                            }
                            
                            if txt == "viewdetails" {
                                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
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
                                
                                let userid = Int.getInt(userTimeLine[indexPath.row].user_id)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                                vc.friendid = userid
                                vc.friendname = String.getString(obj.userdetail?.name)
                                vc.friendimage = imguserurl
                                self.navigationController?.pushViewController(vc, animated: true)
                                self.dismiss(animated: true)
                            }
                            
                            if txt == "Flag"{
                                if UserData.shared.isskiplogin == true{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    self.dismiss(animated: false){
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: FlagPostPopUPVC.getStoryboardID()) as! FlagPostPopUPVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overCurrentContext
                                        let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                        vc.oppid = oppid
                                        self.present(vc, animated: false)
                                        cell.imgOppFlag.isHidden = false
                                    }
                                }
                            }
                            
                            if txt == "Report"{
                                if UserData.shared.isskiplogin == true{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    self.dismiss(animated: false){
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ReportUserPopUpVC.getStoryboardID()) as! ReportUserPopUpVC
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overCurrentContext
                                        let oppid = Int.getInt(userTimeLine[indexPath.row].user_id)
                                        vc.userid = oppid
                                        self.present(vc, animated: false)
                                    }
                                }
                            }
                            
                            if txt == "viewdetails"{
                                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                debugPrint("detailsppid=-=-=",oppid)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                                
                                vc.oppid = oppid
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                        self.present(vc, animated: false)
                    }
                    
                }
                
                //                       COMMENT PART
                
                
                
                if txt == "reply"{
                    
                    let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Seemorecomment"{
                    let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
                if txt == "ClickComment"{
                    if sender.isSelected{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewViewPost.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewViewPost.reloadData()
                        }
                    }else{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewViewPost.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewViewPost.reloadData()
                        }
                    }
                }
                
                if txt == "AddComment"{
                    if cell.txtviewComment.text == ""{
                        self.showSimpleAlert(message: "Please add comment ")
                    }
                    else{
                        let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                        self.commentoppoertunityapi(oppr_id: oppid ?? 0) { userComment in
                            cell.txtviewComment.text = ""
                            cell.viewcomment.isHidden = false
                            cell.heightViewComment.constant = 70
                            cell.lblusernameandcomment.text = String.getString(userComment.first?.name) + " " + String.getString(userComment.first?.comments)
                            debugPrint("lbluserName=-=-=-", cell.lblusernameandcomment.text )
                            
                            let imgcommentuserurl = String.getString(userComment.first?.image)
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            
                            cell.imageCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
                            
                            
                            
                            cell.imageSubcommentUser.isHidden = true
                            cell.lblsubUserNameandComment.isHidden = true
                            
                            
                            let first = String.getString(userComment.first?.name)
                            let second = String.getString(userComment.first?.comments)
                            
                            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
                            
                            attributedString.setColorForText(textToFind: first, withColor: UIColor.black)
                            attributedString.setColorForText(textToFind: second, withColor: UIColor.gray)
                            
                            
                            cell.lblusernameandcomment.attributedText = attributedString
                            self.getallopportunity()
                        }
                    }
                }
                
            }
            
            
            let imgcomment = "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"
            
            cell.imageUser.downlodeImage(serviceurl: imgcomment , placeHolder: UIImage(named: "Boss")) // commentUserImage
            
            cell.viewAddComment.isHidden = obj.isComment == true ? false : true
            cell.heightViewAddComment.constant = obj.isComment == true ? 55 : 0
            
            if obj.usercomment.count == 0{
                cell.viewcomment.isHidden = true
                cell.heightViewComment.constant  = 0
                cell.bottomspacingReply.constant = -90
                //                cell.bottomlblSubcomment.constant = -50
                
            }
            else{
                cell.viewcomment.isHidden = false
                cell.bottomspacingReply.constant = 0
                
            }
            
            if obj.usercomment.first?.subcomment.count == 0 {
                cell.imageSubcommentUser.isHidden = true
                cell.lblsubUserNameandComment.isHidden = true
                cell.VerticalspacingSubComment.constant = 0
                //                cell.bottomlblSubcomment.constant = 10
            }
            else{
                cell.imageSubcommentUser.isHidden = false
                cell.lblsubUserNameandComment.isHidden = false
                cell.VerticalspacingSubComment.constant = 22
                
            }
            
            
            
            cell.lblusernameandcomment.text = String.getString(obj.usercomment.first?.name)
            + "  " + String.getString(obj.usercomment.first?.comments)
            
            let imgcommentuserurl = String.getString(obj.usercomment.first?.image)
            debugPrint("commentuserprofile......",imgcommentuserurl)
            cell.imageCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
            
            
            cell.lblsubUserNameandComment.text = String.getString(obj.usercomment.first?.subcomment.first?.usersubcommentdetails!.name) + "             " + String.getString(obj.usercomment.first?.subcomment.first?.comments) // Sub-Comment
            let imgcommentSubuser = String.getString(obj.usercomment.first?.subcomment.first?.usersubcommentdetails?.image)
            cell.imageSubcommentUser.downlodeImage(serviceurl: imgcommentSubuser, placeHolder: UIImage(named: "Boss"))
            
            
            let first = String.getString(obj.usercomment.first?.name)
            let second = String.getString(obj.usercomment.first?.comments)
            
            let thrid = String.getString(obj.usercomment.first?.subcomment.first?.usersubcommentdetails!.name)
            let fourth = String.getString(obj.usercomment.first?.subcomment.first?.comments)
            
            let attributedStringcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
            
            let attributedStringSubcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(thrid)  \(fourth)")
            
            attributedStringcomment.setColorForText(textToFind: first, withColor: UIColor.black)
            attributedStringcomment.setColorForText(textToFind: second, withColor: UIColor.gray)
            
            attributedStringSubcomment.setColorForText(textToFind: thrid, withColor: UIColor.black)
            attributedStringSubcomment.setColorForText(textToFind: fourth, withColor: UIColor.gray)
            
            
            cell.lblusernameandcomment.attributedText = attributedStringcomment
            cell.lblsubUserNameandComment.attributedText = attributedStringSubcomment
            
            
            cell.callbacktextviewcomment = {[weak tblViewViewPost] (_) in
                
                self.txtcomment = cell.txtviewComment.text
                self.tblViewViewPost?.beginUpdates()
                self.tblViewViewPost?.endUpdates()
            }
            
            
            //                cell.layoutIfNeeded()
            return cell
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            if UserData.shared.isskiplogin == true{
                return 150
            }
            else{
                return 370
            }
            
        case 1:
            return UITableView.automaticDimension
            
            
        default:
            return 0
        }
        
    }
}



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
                        
                        self.imgUrl = String.getString(dictResult["oprbase_url"])
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
            "opr_id":opr_id
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
    
    //    Api like Opportunity
    
    func likeOpportunityapi(oppr_id:Int,completion: @escaping(_ countLike: String)->Void){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.klikeopportunity, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    //                    self?.statuslike = Int.getInt(dictResult["status"])
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        //  self?.count = String.getString(dictResult["count"])
                        debugPrint("likecount=-=-=",self?.count)
                        completion(String.getString(dictResult["count"]))
                        
                        
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kaddcomment, requestMethod: .POST,
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
                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
    
    
    //    Save Opportunity Api
    
    func saveoppoertunityapi(oppr_id:Int){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksaveOpp, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
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
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
    //    Unsaved Opportunity
    
    func unsaveoppoertunityapi(oppr_id:Int){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kunsavedopp, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
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
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        //                        self?.TblViewSavedOpp.reloadData()
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
                CommonUtils.showToastForDefaultError()
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
                        
                        self.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("Dataallpost=\(userTimeLine)")
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.tblViewViewPost.reloadData()
                        self.lblUserName.text = String.getString("Guest User")
                        self.ImgUser.image = UIImage(named: "Boss")
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kopportunitydetails, requestMethod: .POST,
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
                        print("DataAllPremiumPost===\(userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kopportunitydetails, requestMethod: .POST,
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
                        self.imgNotification.isHidden = false
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self.imgNotification.isHidden = false
                        self.imgNotification.image = UIImage(named: "notification-bing-1")
                        
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

extension NSMutableAttributedString {
    
    func setColorForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

extension HomeVC{
    func setuplanguage(){
        lblHello.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Hello", comment: "")
    }
}
