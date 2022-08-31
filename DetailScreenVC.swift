//
//  DetailScreenVC.swift
//  Dawadawa
//
//  Created by Alekh on 25/08/22.
//

import UIKit

class DetailScreenVC: UIViewController {
    
    @IBOutlet weak var tblviewDetail: UITableView!
    var imgUrl = ""
    var userTimeLine: SocialPostData?
    var img = [oppr_image]()
    var oppid = 0
    
    
    var txtcomment = " "
    var comment = [user_comment]()
    var subcomment  = [sub_Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getalldetail()
        tblviewDetail.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        tblviewDetail.register(UINib(nibName: "SeeMoreCommentCell", bundle: Bundle.main), forCellReuseIdentifier: "SeeMoreCommentCell")
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        kSharedAppDelegate?.makeRootViewController()
    }
    
}

extension DetailScreenVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return 1
            
        case 1:
            return self.userTimeLine?.usercomment.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            
            
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(self.userTimeLine?.userdetail?.name)
            cell.lblDescribtion.text = String.getString(self.userTimeLine?.description)
            cell.lblTitle.text = String.getString(self.userTimeLine?.title)
            cell.viewAddComment.isHidden = self.userTimeLine?.isComment == false ? true : false
            cell.heightViewAddComment.constant = self.userTimeLine?.isComment == false ? 0 : 55
            
            let imgurl = String.getString(self.userTimeLine?.userdetail?.image)
            debugPrint("socialprofile......",imgurl)
            cell.Imageuser.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
            cell.img = self.userTimeLine?.oppimage ?? []
            cell.imgUrl = self.imgUrl
            
            cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes) + " " + "Likes"
            
            if Int.getInt(self.userTimeLine?.close_opr) == 0{
                cell.lblTitle.text = String.getString(self.userTimeLine?.title)
                cell.lblTitle.textColor = .black
            }
            else{
                cell.lblTitle.text = "This Opprortunity has been Closed"
                cell.lblTitle.textColor = .red
            }
            if String.getString(self.userTimeLine?.is_user_like) == "1"{
                cell.imglike.image = UIImage(named: "dil")
                cell.lbllike.text = "Liked"
                
            }
            else{
                cell.imglike.image = UIImage(named: "unlike")
                cell.lbllike.text = "Like"
            }
            if String.getString(self.userTimeLine?.is_saved) == "1"{
                cell.imgsave.image = UIImage(named: "saveopr")
                cell.lblSave.text = "Saved"
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                cell.lblSave.text = "Save"
            }
            if Int.getInt(self.userTimeLine?.oppimage.count) == 0{
                cell.heightSocialPostCollectionView.constant = 0
            }
            else{
                cell.heightSocialPostCollectionView.constant = 225
            }
            
            
            
            cell.callback = { txt, tapped in
                
                if txt == "Like"{
                    
                    //                            self.likeOpportunityapi(oppr_id: oppid ?? 0)
                    self.likeOpportunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0) { countLike in
                        self.userTimeLine?.likes = Int.getInt(countLike)
                        cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes) + " " + "likes"
                    }
                    cell.imglike.image = UIImage(named: "dil")
                    cell.lbllike.text = "Liked"
                    
                }
                
                if txt == "Save"{
                    
                    self.saveoppoertunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0)
                    cell.imgsave.image = UIImage(named: "saveopr")
                    cell.lblSave.text = "Saved"
                }
                
                if txt == "More" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callback = { txt in
                        //                    if txt == "Dismiss"{
                        //                        vc.dismiss(animated: false){
                        //                            self.dismiss(animated: true, completion: nil)
                        //                        }
                        //                    }
                        if txt == "Flag"{
                            
                            //                                let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
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
                
                cell.imageUser.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss")) // Comment_ImageUser
                
                
                
                if txt == "AddComment"{
                    if cell.txtviewComment.text == ""{
                        self.showSimpleAlert(message: "Please add comment ")
                    }
                    else{
                        self.commentoppoertunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0) { userComment in
                            cell.txtviewComment.text = ""
                            
                            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SeeMoreCommentCell") as! SeeMoreCommentCell
                            cell.lblNameandComment.text = String.getString(userComment.first?.name) + " " + String.getString(userComment.first?.comments)
                            debugPrint("lblcommentName=-=-=-", cell.lblNameandComment.text )
                            
                            let imgcommentuserurl = String.getString(userComment.first?.image)
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            
                            cell.imgCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
                            
                            self.getalldetail()
                            
                        }
                    }
                }
                
            }
            cell.viewcomment.isHidden = true
            cell.heightViewComment.constant = 0
            cell.bottomspacingReply.constant = -90
            
            
            
            cell.callbacktextviewcomment = {[weak tblviewDetail] (_) in
                
                self.txtcomment = cell.txtviewComment.text
                debugPrint("txtcomment=-=-=-=",self.txtcomment)
                self.tblviewDetail?.beginUpdates()
                self.tblviewDetail?.endUpdates()
                
            }
            
            
            return cell
            
        case 1:
            
            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SeeMoreCommentCell") as! SeeMoreCommentCell
            
            let obj = self.userTimeLine?.usercomment[indexPath.row]
            cell.topsubTableview.constant = obj?.subcomment.count == 0 ? 0 : 10
            cell.bottomSubtableview.constant = obj?.subcomment.count == 0 ? 0 : 10
            cell.viewPostComment.isHidden = obj?.subcomment.count == 0 ? false : true
            cell.heightViewPostComment.constant = obj?.isReply == true ? 70 : 0
            cell.viewPostComment.isHidden = obj?.isReply == true ? false : true
            cell.btnReply.isHidden = obj?.isReply == true ? true : false
            cell.heightReply.constant = obj?.isReply == true ? -25 : 0
            
            
            cell.lblNameandComment.text = String.getString(obj?.name) + "   " + String.getString(obj?.comments)
            let imgcommentuser = String.getString(obj?.image)
            cell.imgCommentUser.downlodeImage(serviceurl: imgcommentuser, placeHolder: UIImage(named: "Boss"))
            
            if obj?.subcomment.count == 0{
                cell.heightTableView.constant = 2
            }else{
                cell.heightTableView.constant = CGFloat(35 * (obj?.subcomment.count)!)
                //               cell.tblviewSubComment.estimatedRowHeight = 35
                
                
            }
            cell.subcomment = obj?.subcomment ?? []
            cell.reloadTable()
            print("datacount---",cell.subcomment.count)
            
            
            
            cell.callback = { txt in
                
                if txt == "Reply"{
                    obj?.isReply = true
                    self.tblviewDetail.reloadData()
                }
                else if txt == "Cancel"{
                    obj?.isReply = false
                    self.tblviewDetail.reloadData()
                }
                
                if txt == "Post"{
                    
                    if cell.txtviewsubComment.text == ""{
                        self.showSimpleAlert(message: "Please add reply")
                    }
                    else{
                        self.commentreplyapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0, commentid:Int.getInt(self.userTimeLine?.usercomment[indexPath.row].id)) { usersubComment in

                            
                            cell.txtviewsubComment.text = ""
                            cell.lblNameandComment.text = String.getString(usersubComment.first?.usersubcommentdetails?.name) + " " + String.getString(usersubComment.first?.comments)
                            debugPrint("lblcommentName=-=-=-", cell.lblNameandComment.text )
                            
                            let imgcommentuserurl = String.getString(usersubComment.first?.usersubcommentdetails?.image)
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            
                            cell.imgCommentUser.downlodeImage(serviceurl: imgcommentuserurl , placeHolder: UIImage(named: "Boss"))
                            
                            cell.viewPostComment.isHidden = true
                            self.getalldetail()
                            
                        }
                    }
                
                    
                }
                
            }
            
            cell.callbacktxtviewsubcomment = {[weak tblviewDetail] (_) in
                
                self.txtcomment = cell.txtviewsubComment.text
                debugPrint("txtSubcomment=-=-=-=",self.txtcomment)
                self.tblviewDetail?.beginUpdates()
                self.tblviewDetail?.endUpdates()
                
            }
            
            
            let first = String.getString(obj?.name)
            let second = String.getString(obj?.comments)

            let attributedStringcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")

            attributedStringcomment.setColorForText(textToFind: first, withColor: UIColor.black)
            attributedStringcomment.setColorForText(textToFind: second, withColor: UIColor.gray)

            cell.lblNameandComment.attributedText = attributedStringcomment
            
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return UITableView.automaticDimension
            
            
        case 1:
            return UITableView.automaticDimension
            
            
        default:
            return 0
        }
        
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
