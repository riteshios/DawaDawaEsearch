//
//  SearchVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class SearchVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var tblViewSearchOpp: UITableView!
    @IBOutlet weak var txtfieldSearch: UITextField!
    @IBOutlet weak var imgNotfound: UIImageView!
    
    @IBOutlet weak var viewSearch: UIView!
    
    var imgUrl = ""
    var docUrl = ""
    var userTimeLine = [SocialPostData]()
    var UserTimeLineOppdetails:SocialPostData?
    var img = [oppr_image]()
    var comment = [user_comment]()
    var txtcomment = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgNotfound.isHidden = true
        self.setup()
        
        viewSearch.addShadowWithBlurOnView(viewSearch, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        self.hidesBottomBarWhenPushed = false
    //        self.tabBarController?.tabBar.isHidden = false
    //        self.tabBarController?.hidesBottomBarWhenPushed = false
    //        self.tabBarController?.tabBar.layer.zPosition = 0
    //    }
    
    
    
    func setup(){
        tblViewSearchOpp.register(UINib(nibName: "PopularSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PopularSearchTableViewCell")
        
        tblViewSearchOpp.register(UINib(nibName: "PremiumOppTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumOppTableViewCell")
        
        tblViewSearchOpp.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        txtfieldSearch.delegate = self
        txtfieldSearch.returnKeyType = .done
    }
}
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
            return userTimeLine.count
            
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
                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                }
                else{
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
            
            
            
        case 2:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]
            
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            debugPrint("username.....", cell.lblUserName.text)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.lblRating.text = String.getString(obj.opr_rating)
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            let imgurl = String.getString(obj.userdetail?.social_profile)
            debugPrint("socialprofile......",imgurl)
            
            cell.Imageuser.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
            
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
            
            
            
            cell.callback = { txt, sender in
                
                if txt == "Profileimage"{
                    let user_id = self.userTimeLine[indexPath.row].user_id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = user_id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                if txt == "Like"{
                    if UserData.shared.isskiplogin == true{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                    }
                    else{
                        let oppid = self.userTimeLine[indexPath.row].id
                        debugPrint("oppid--=-=-=-",oppid)
                        //                            self.likeOpportunityapi(oppr_id: oppid ?? 0)
                        self.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike in
                            obj.likes = Int.getInt(countLike)
                            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
                        }
                        cell.imglike.image = UIImage(named: "dil")
                        cell.lbllike.text = "Liked"
                        self.searchopportunityapi()
                        
                    }
                }
                
                if txt == "Rate"{
                    let oppid = self.userTimeLine[indexPath.row].id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: RateOpportunityPopUPVC.getStoryboardID()) as! RateOpportunityPopUPVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.oppid = oppid ?? 0
            
                    vc.callbackClosure = {
                        self.searchopportunityapi()
                    }
                    self.present(vc, animated: false)
                    
                }
                
                if txt == "Save"{
                    if sender.isSelected{
                        
                        if String.getString(obj.is_saved) == "0"{
                            let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                            debugPrint("saveoppid=-=-=",oppid)
                            self.saveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "saveopr")
                            cell.lblSave.text = "Saved"
                        }
                        else{
                            let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                            self.unsaveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "save-3")
                            cell.lblSave.text = "Save"
                        }
                        
                    }
                    else{
                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
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
                                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                    
                                    debugPrint("oppid+++++++",oppid)
                                    
                                    self.opportunitydetailsapi(oppr_id: oppid)
                                }
                            }
                            
                        }
                        self.present(vc, animated: false)
                        
                    }
                    
                    else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.callback = { txt in
                            
                            if txt == "Flag"{
                                if UserData.shared.isskiplogin == true{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                    self.flagopportunityapi(oppr_id: oppid)
                                    self.dismiss(animated: true)
                                    cell.imgOppFlag.isHidden = false
                                }
                            }
                            
                            if txt == "Report"{
                                if UserData.shared.isskiplogin == true{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    kSharedAppDelegate?.makeRootViewController()
                                }
                                
                            }
                            
                        }
                        self.present(vc, animated: false)
                    }
                }
                
                //                       COMMENT PART
                
                
                if txt == "reply"{
                    
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Seemorecomment"{
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
                
                if txt == "ClickComment"{
                    if sender.isSelected{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewSearchOpp.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewSearchOpp.reloadData()
                        }
                    }else{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewSearchOpp.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewSearchOpp.reloadData()
                        }
                    }
                }
                
                if txt == "AddComment"{
                    if cell.txtviewComment.text == ""{
                        self.showSimpleAlert(message: "Please add comment ")
                    }
                    else{
                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                        self.commentoppoertunityapi(oppr_id: oppid ?? 0) { userComment in
                            cell.txtviewComment.text = ""
                            cell.viewcomment.isHidden = false
                            cell.heightViewComment.constant = 70
                            cell.lblusernameandcomment.text = String.getString(userComment.first?.name) + " " + String.getString(userComment.first?.comments)
                            debugPrint("lbluserName=-=-=-", cell.lblusernameandcomment.text )
                            
                            let imgcommentuserurl = String.getString(userComment.first?.image)
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            
                            cell.imageCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
                            
                            cell.viewcomment.isHidden = false
                            
                            cell.imageSubcommentUser.isHidden = true
                            cell.lblsubUserNameandComment.isHidden = true
                            cell.verticalSpacingReply.constant = -10
                            //                            cell.bottomlblSubcomment.constant = 10
                            
                            
                            let first = String.getString(userComment.first?.name)
                            let second = String.getString(userComment.first?.comments)
                            
                            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
                            
                            attributedString.setColorForText(textToFind: first, withColor: UIColor.black)
                            attributedString.setColorForText(textToFind: second, withColor: UIColor.gray)
                            
                            
                            cell.lblusernameandcomment.attributedText = attributedString
                            self.searchopportunityapi()
                            
                        }
                    }
                }
                
            }
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
            
            let imgcomment = "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"
            
            cell.imageUser.downlodeImage(serviceurl: imgcomment , placeHolder: UIImage(named: "Boss")) // commentUserImage
            
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
            
            
            
            cell.callbacktextviewcomment = {[weak tblViewSearchOpp] (_) in
                
                self.txtcomment = cell.txtviewComment.text
                self.tblViewSearchOpp?.beginUpdates()
                self.tblViewSearchOpp?.endUpdates()
            }
            
            
            
            
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
            return UITableView.automaticDimension
            
        case 2:
            
            return UITableView.automaticDimension
            
            
        default:
            return 0
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
        
        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksearchopportunity, requestMethod: .POST,
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
                        
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                        
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
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
                        
                        //                        self?.count = String.getString(dictResult["count"])
                        //                        debugPrint("likecount=-=-=-=",self?.count)
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
    
    // Api flag Opportunity
    
    func flagopportunityapi(oppr_id:Int){
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
            //            "user_id":Int.getInt(UserData.shared.id),
            "opr_id":oppr_id,
            "user_id":UserData.shared.id
        ]
        
        debugPrint("opr_id......",oppr_id)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kflagpost, requestMethod: .POST,
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
                        //                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        
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
    
    //    Guest Search api
    
    func guestsearchopportunityapi(){
        CommonUtils.showHud(show: true)
        
        
        let params:[String : Any] = [
            "search":String.getString(self.txtfieldSearch.text)
            
        ]
        
        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestsearchopportunity, requestMethod: .POST,
                                                       requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                        
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
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
}
