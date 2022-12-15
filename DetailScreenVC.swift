//  DetailScreenVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 25/08/22.

import UIKit
import StripeUICore

class DetailScreenVC: UIViewController{
    
    @IBOutlet weak var tblviewDetail: UITableView!
    @IBOutlet weak var lblDetailScreen: UILabel!
    var imgUrl = ""
    var userTimeLine: SocialPostData?
    var img = [oppr_image]()
    var oppid = 0
    
    var txtcomment = " "
    var comment = [user_comment]()
    var subcomment  = [sub_Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        tblviewDetail.register(UINib(nibName: "DetailsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DetailsTableViewCell")
        tblviewDetail.register(UINib(nibName: "SeeMoreCommentCell", bundle: Bundle.main), forCellReuseIdentifier: "SeeMoreCommentCell")
        tblviewDetail.register(UINib(nibName: "SubCommentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubCommentTableViewCell")
        tblviewDetail.register(UINib(nibName: "CommentHeaderView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "CommentHeaderView")
        tblviewDetail.register(UINib(nibName: "FooterView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "FooterView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getalldetail()
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        kSharedAppDelegate?.makeRootViewController()
    }
}

extension DetailScreenVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.userTimeLine?.usercomment.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
            
        }else{
            return self.userTimeLine?.usercomment[section - 1].subcomment.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return UIView()
            
        }else{
            let view = tblviewDetail.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeaderView") as! CommentHeaderView
            let obj = self.userTimeLine?.usercomment[section - 1]
            // view.labelName.text = obj?.comments
            let first = String.getString(obj?.name)
            let second = String.getString(obj?.comments)
            let attributedStringcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
            attributedStringcomment.setColorForText(textToFind: first, withColor: UIColor.black)
            attributedStringcomment.setColorForText(textToFind: second, withColor: UIColor.gray)
            view.labelName.attributedText = attributedStringcomment
            
            let imgurl = URL(string: String.getString(obj?.image))
            view.labelImage.sd_setImage(with: imgurl)
            
            view.callBack = { txt in
                if txt == "detail"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = Int.getInt(obj?.user_id)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            return UIView()
            
        }else{
            let view = tblviewDetail.dequeueReusableHeaderFooterView(withIdentifier: "FooterView") as! FooterView
            let obj = self.userTimeLine?.usercomment[section - 1]
            
            view.buttonReply.isHidden = obj?.isReply == true ? true : false
            view.heightButtonReply.constant = obj?.isReply == true ? 0 : 30
            view.viewAddPost.isHidden = obj?.isReply == true ? false : true
            view.heightAddPost.constant = obj?.isReply == true ? 73 : 0
            view.delegate()
            view.callbacktxtviewsubcomment = {[weak tblviewDetail] (_) in
                self.txtcomment = view.textview.text
                debugPrint("txtSubcomment=-=-=-=",self.txtcomment)
                self.tblviewDetail?.beginUpdates()
                self.tblviewDetail?.endUpdates()
            }
            
            view.callBack = { txt in
                if txt == "reply"{
                    obj?.isReply = true
                    view.viewAddPost.isHidden = false
                    view.heightAddPost.constant = 73
                    view.buttonReply.isHidden = true
                    view.heightButtonReply.constant = 0
                    self.tblviewDetail.reloadData()
                    
                }else if txt == "post"{
                    if self.txtcomment == ""{
                        self.showSimpleAlert(message: "Please add reply")
                    }else{
                        self.commentreplyapi(oppr_id: Int.getInt(self.userTimeLine?.id) , commentid:Int.getInt(obj?.id)) { usersubComment in
                            view.textview.text = ""
                            self.txtcomment = ""
                            obj?.isReply = false
                            //  self.tblviewDetail.reloadData()
                            self.getalldetail()
                        }
                    }
                }else if txt == "cancel" {
                    
                    obj?.isReply = false
                    view.textview.text = ""
                    view.viewAddPost.isHidden = true
                    view.heightAddPost.constant = 0
                    view.buttonReply.isHidden = false
                    view.heightButtonReply.constant = 30
                    self.tblviewDetail.reloadData()
                }
            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "DetailsTableViewCell") as! DetailsTableViewCell
            
            //            cell.viewLine.isHidden = true
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.DocumentCollectionView.tag = indexPath.section
            
            cell.lblUserName.text = String.getString(self.userTimeLine?.userdetail?.name)
            cell.lblDescribtion.text = String.getString(self.userTimeLine?.description)
            cell.lblEmail.text = String.getString(self.userTimeLine?.userdetail?.email)
            cell.lblTitle.text = String.getString(self.userTimeLine?.title)
            cell.viewAddComment.isHidden = self.userTimeLine?.isComment == false ? true : false
            cell.heightAddComment.constant = self.userTimeLine?.isComment == false ? 0 : 55
            //          cell.heightViewAddComment.constant = self.userTimeLine?.isComment == false ? 0 : 55
            cell.lblCategory.text = String.getString(self.userTimeLine?.category_name)
            cell.lblSub_category.text = String.getString(self.userTimeLine?.subcategory_name)
            
            if UserData.shared.id == self.userTimeLine?.user_id{
                cell.btnChat.isHidden = true
                cell.viewSave.isHidden = true
            }
            else{
                cell.btnChat.isHidden = false
                cell.viewSave.isHidden = false
            }
            
            if String.getString(self.userTimeLine?.business_name) == "Null"{
                cell.heightViewBusinessName.constant = 0
                cell.ViewBusinessName.isHidden = true
            }
            else{
                cell.lblBusinessName.text = String.getString(self.userTimeLine?.business_name)
            }
            if String.getString(self.userTimeLine?.business_mining_type) == "Null"{
                cell.heightviewBusinessminingtype.constant = 0
                cell.viewBusinessminingType.isHidden = true
            }
            else{
                cell.lblBusinessminingType.text = String.getString(self.userTimeLine?.business_mining_type)
            }
            cell.llbMobileNumber.text =  String.getString(self.userTimeLine?.mobile_num)
            cell.lblRating.text = String.getString(self.userTimeLine?.opr_rating)
            cell.imgOpp_plan.image = self.userTimeLine?.opp_plan == "Featured" ? UIImage(named: "Star Filled") : self.userTimeLine?.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "Folded Booklet")
            
            if String.getString(self.userTimeLine?.looking_for) == "0"{
                cell.lblLookingFor.text = "Looking for Investor"
            }
            else if String.getString(self.userTimeLine?.looking_for) == "1"{
                cell.lblLookingFor.text = "Looking for Business Owner"
            }
            else if String.getString(self.userTimeLine?.looking_for) == "2"{
                cell.lblLookingFor.text = "Looking for Service Provider"
            }
            
            if String.getString(self.userTimeLine?.location_name) != ""{
                cell.lblLocationName.text = String.getString(self.userTimeLine?.location_name)
                cell.lblLocationName.textColor = UIColor.black
            }
            else{
                cell.lblLocationName.text = "Location not available"
                cell.lblLocationName.textColor = UIColor.gray
            }
            
            if String.getString(self.userTimeLine?.location_map) != ""{
                cell.lblLocationONMap.text = String.getString(self.userTimeLine?.location_map)
                cell.lblLocationONMap.textColor = UIColor.black
            }
            else{
                cell.lblLocationONMap.text = "Location on map not available"
                cell.lblLocationONMap.textColor = UIColor.gray
            }
            
            if String.getString(self.userTimeLine?.whatsaap_num) != ""{
                cell.lbblWhatsappNumber.text = String.getString(self.userTimeLine?.whatsaap_num)
                cell.lbblWhatsappNumber.textColor = UIColor.black
            }
            else{
                cell.lbblWhatsappNumber.text = "Not available"
                cell.lbblWhatsappNumber.textColor = UIColor.gray
            }
            
            if String.getString(self.userTimeLine?.plan_name) == "Basic Plan"{
                cell.lblLocationONMap.text = "Not for basic Plan"
                cell.lblLocationONMap.textColor = UIColor.gray
                cell.lbblWhatsappNumber.text = "Not for basic Plan"
                cell.lbblWhatsappNumber.textColor = UIColor.gray
                cell.llbMobileNumber.text = "Not for basic Plan"
                cell.llbMobileNumber.textColor = UIColor.gray
                cell.DocumentCollectionView.isHidden = true
                cell.lblEmail.text = "Not for basic Plan"
                cell.lblEmail.textColor = UIColor.gray
                cell.heightDocumentcollectionview.constant = 0
            }
            
            else if String.getString(self.userTimeLine?.plan_name) == "Silver Plan"{
                cell.lblLocationONMap.text = "Not for Silver Plan"
                cell.lblLocationONMap.textColor = UIColor.gray
                cell.lbblWhatsappNumber.text = "Not for Silver Plan"
                cell.lbblWhatsappNumber.textColor = UIColor.gray
                cell.llbMobileNumber.text = "Not for Silver Plan"
                cell.llbMobileNumber.textColor = UIColor.gray
                cell.DocumentCollectionView.isHidden = true
                cell.lblEmail.text = "Not forSilver Plan"
                cell.lblEmail.textColor = UIColor.gray
                cell.heightDocumentcollectionview.constant = 0
            }
            
            let imguserurl = String.getString(self.userTimeLine?.userdetail?.image)
            debugPrint("socialprofile......",imguserurl)
            cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
            cell.img = self.userTimeLine?.oppimage ?? [] // Collection View k liye image pass kr rhe h
            cell.imgUrl = self.imgUrl
            cell.doc = self.userTimeLine?.oppdocument ?? [] // Pass Doc for collection view
            cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes) + " " + "Likes"
            cell.heightDocumentcollectionview.constant = self.userTimeLine?.oppdocument.count == 0 ? 0 : 60
            
            if String.getString(self.userTimeLine?.is_user_like) == "1"{
                cell.imglike.image = UIImage(named: "dil")
                cell.lbllike.text = "Liked"
                cell.lbllike.textColor = .red
                
            }
            else{
                cell.imglike.image = UIImage(named: "unlike")
                cell.lbllike.text = "Like"
                cell.lbllike.textColor = UIColor(hexString: "#A6A6A6")
            }
            if String.getString(self.userTimeLine?.is_saved) == "1"{
                cell.imgsave.image = UIImage(named: "saveopr")
                cell.lblSave.text = "Saved"
                cell.lblSave.textColor = UIColor(hexString: "#1572A1")
                
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                cell.lblSave.text = "Save"
                cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
            }
            if Int.getInt(self.userTimeLine?.oppimage.count) == 0{
                cell.heightSocialPostCollectionView.constant = 0
            }
            else{
                cell.heightSocialPostCollectionView.constant = 225
            }
            cell.callback = { txt, tapped in
                
                if txt == "Profileimage"{
                    let user_id = self.userTimeLine?.user_id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = user_id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if txt == "Chat"{
                    let userid = Int.getInt(self.userTimeLine?.user_id)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                    vc.friendid = userid
                    vc.friendname = String.getString(self.userTimeLine?.userdetail?.name)
                    vc.friendimage = imguserurl
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if txt == "Like"{
                    //  self.likeOpportunityapi(oppr_id: oppid ?? 0)
                    self.likeOpportunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0) { countLike in
                        self.userTimeLine?.likes = Int.getInt(countLike)
                        cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes) + " " + "likes"
                    }
                    cell.imglike.image = UIImage(named: "dil")
                    cell.lbllike.text = "Liked"
                    cell.lbllike.textColor = .red
                }
                
                if txt == "Rate"{
                    let oppid = Int.getInt(self.userTimeLine?.id)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: RateOpportunityPopUPVC.getStoryboardID()) as! RateOpportunityPopUPVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.oppid = oppid ?? 0
                    
                    vc.callbackClosure = {
                        self.getalldetail()
                    }
                    self.present(vc, animated: false)
                    
                }
                if txt == "Save"{
                    if tapped.isSelected{
                        
                        if String.getString(self.userTimeLine?.is_saved) == "0"{
                            let oppid = Int.getInt(self.userTimeLine?.id)
                            debugPrint("saveoppid=-=-=",oppid)
                            self.saveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "saveopr")
                            cell.lblSave.text = "Saved"
                            cell.lblSave.textColor = UIColor(hexString: "#1572A1")
                            self.getalldetail()
                        }
                        else{
                            let oppid = Int.getInt(self.userTimeLine?.id)
                            self.unsaveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "save-3")
                            cell.lblSave.text = "Save"
                            cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
                            self.getalldetail()
                        }
                    }
                    else{
                        let oppid = Int.getInt(self.userTimeLine?.id)
                        self.unsaveoppoertunityapi(oppr_id: oppid)
                        cell.imgsave.image = UIImage(named: "save-3")
                        cell.lblSave.text = "Save"
                        cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
                        self.getalldetail()
                    }
                }
                
                if txt == "More" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.hascamefrom = "DetailPage"
                    vc.callback = { txt in
                        
                        if txt == "Chatwithuser"{
                            let userid = Int.getInt(self.userTimeLine?.user_id)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                            vc.friendid = userid
                            vc.friendname = String.getString(self.userTimeLine?.userdetail?.name)
                            vc.friendimage = imguserurl
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.dismiss(animated: true)
                        }
                        
                        if txt == "MarkasInterested"{
                            let oppid = Int.getInt(self.userTimeLine?.id)
                            self.markinterestedapi(oppr_id: oppid)
                            self.dismiss(animated: true)
                        }
                        
                        if txt == "Flag"{
                            //                            let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                            self.flagopportunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0)
                        }
                        
                        if txt == "Report"{
                            kSharedAppDelegate?.makeRootViewController()
                        }
                    }
                    self.present(vc, animated: false)
                }
                
                //                Comment Part
                
                if txt == "ClickComment"{
                    if tapped.isSelected {
                        self.userTimeLine?.isComment = true
                        self.tblviewDetail.reloadData()
                    }else{
                        self.userTimeLine?.isComment = false
                        self.tblviewDetail.reloadData()
                    }
                }
                
                cell.imageUser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss")) // Comment_ImageUser
                
                if txt == "AddComment"{
                    if cell.txtviewComment.text == ""{
                        self.showSimpleAlert(message: "Please add comment ")
                    }
                    else{
                        self.commentoppoertunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0) { userComment in
                            cell.txtviewComment.text = ""
                            
                            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SeeMoreCommentCell") as! SeeMoreCommentCell
                            
                            cell.lblNameandComment.text = String.getString(userComment.first?.name) + " " + String.getString(userComment.first?.comments)
                            
                            debugPrint("lblcommentName====-", cell.lblNameandComment.text )
                            
                            let imgcommentuserurl = String.getString(userComment.first?.image)
                            
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            
                            cell.imgCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
                            
                            self.getalldetail()
                        }
                    }
                }
            }
            //            cell.viewcomment.isHidden = true
            //            cell.heightViewComment.constant = 0
            //            cell.bottomspacingReply.constant = -90
            cell.callbacktextviewcomment = {[weak tblviewDetail] (_) in
                
                self.txtcomment = cell.txtviewComment.text
                debugPrint("txtcomment=-=-=-=",self.txtcomment)
                self.tblviewDetail?.beginUpdates()
                self.tblviewDetail?.endUpdates()
            }
            return cell
            
        }
        else{
            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SubCommentTableViewCell") as! SubCommentTableViewCell
            let obj = self.userTimeLine?.usercomment[indexPath.section - 1].subcomment[indexPath.row]
            let first = String.getString(obj?.usersubcommentdetails?.name)
            let second = String.getString(obj?.comments)
            let attributedStringcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
            attributedStringcomment.setColorForText(textToFind: first, withColor: UIColor.black)
            attributedStringcomment.setColorForText(textToFind: second, withColor: UIColor.gray)
            cell.lblSubComment.attributedText = attributedStringcomment
            let imgurl = URL(string: String.getString(obj?.usersubcommentdetails?.image))
            cell.imgSubCommentUser.sd_setImage(with: imgurl, placeholderImage:UIImage(named: "Boss"))
            
            cell.callBack = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                vc.userid = Int.getInt(obj?.usersubcommentdetails?.id)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
    
}

func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
    
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    }
}

// MARK: - APi call
extension DetailScreenVC{
    
    //    Api Detail Opportunity
    
    func getalldetail(){
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
            "oppr_id":self.oppid,
            "user_id":UserData.shared.id
        ]
        
        debugPrint("oppr_id...===...",oppid)
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
                        
                        let Opportunity = kSharedInstance.getDictionary(dictResult["Opportunity"])
                        self?.userTimeLine = SocialPostData(data: Opportunity)
                        
                        print("DataAlldetails===\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblviewDetail.reloadData()
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
    
    //    Api Sub-comment opportunity
    
    func commentreplyapi(oppr_id:Int,commentid:Int,completion: @escaping(_ viewH : [sub_Comment])->Void){
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
            "comment_id":commentid,
            "user_id":Int.getInt(UserData.shared.id),
            "opr_id":oppr_id,
            "comment":String.getString(self.txtcomment)
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kcommentreply, requestMethod: .POST,
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
                        
                        let sub_comment = kSharedInstance.getArray(withDictionary: dictResult["user_comment"])
                        debugPrint("Commentdata=-=-=1-=",sub_comment)
                        self?.subcomment = sub_comment.map{sub_Comment(data: kSharedInstance.getDictionary($0))}
                        //                        debugPrint("Commentdata=-=-=0-=", self?.subcomment.comments)
                        completion(self!.subcomment)
                        debugPrint("CommentData=-=-=0-=",completion(self!.subcomment))
                        
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
            "opr_id":oppr_id
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
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        kSharedAppDelegate?.makeRootViewController()
                        
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

extension DetailScreenVC{
    func setuplanguage(){
        lblDetailScreen.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Detail Screen", comment: "")
    }
}



