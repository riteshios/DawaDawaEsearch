//  SocialPostTVC.swift
//  Dawadawa
//  Created by Ritesh  on 26/03/23.

import UIKit


class SocialPostTVC: UITableViewCell {

//    MARK: - Properties : - 
    @IBOutlet weak var SocialPostCV: UICollectionView!
    @IBOutlet weak var HeightSocialPostCV: NSLayoutConstraint!
    
    weak var celldelegate: NewSocialPostCVCDelegate?
   lazy var globalApi = {
        GlobalApi()
    }()
    
//    MARK: - Life Cycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SocialPostCV.delegate = self
        SocialPostCV.dataSource = self
        SocialPostCV.register(UINib(nibName: "NewSocialPostCVC", bundle: nil), forCellWithReuseIdentifier: "NewSocialPostCVC")
        self.getallopportunity()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//    MARK: - TableView Delegate -


extension SocialPostTVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTimeLine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCV.dequeueReusableCell(withReuseIdentifier: "NewSocialPostCVC", for: indexPath) as! NewSocialPostCVC
        self.HeightSocialPostCV.constant = self.SocialPostCV.contentSize.height
        let obj = userTimeLine[indexPath.row]
        let imguserurl = String.getString(obj.userdetail?.social_profile)
        
        cell.lblUserName.text = String.getString(obj.userdetail?.name)
        cell.lblTitle.text = String.getString(obj.title)
        cell.lblCategoryName.text = String.getString(obj.category_name)
        cell.lblRating.text = String.getString(obj.opr_rating)
        cell.lblCommentCout.text = String.getString(Int.getInt(obj.commentsCount))
        cell.lblLikeCount.text = String.getString(obj.likes)
        
        let imageurl = "\(imgUrl)/\(String.getString(obj.oppimage.first?.imageurl))"
        print("imagebaseurl=-=-\(imageurl)")
        let userUrl = URL(string: imageurl)
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "Banner"))
        
        if String.getString(obj.opr_rating) == ""{
            cell.lblRating.text = "0.0"
        }
        else{
            cell.lblRating.text = String.getString(obj.opr_rating)
        }
        if Int.getInt(obj.close_opr) == 0{
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblTitle.textColor = .black
            cell.lblcloseOpportunity.text = "Available"
            cell.lblcloseOpportunity.textColor = UIColor(hexString: "#20D273")
        }
        else {
            cell.lblcloseOpportunity.text = "Closed"
            cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
        }
        
        if String.getString(obj.is_user_like) == "1"{
            cell.imglike.image = UIImage(named: "dil")
            
        }
        else {
            cell.imglike.image = UIImage(named: "unlike")
        }
        
        cell.callback  = {txt, sender in
            
            if txt == "viewDetails"{
                    let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                    opppreid = oppid ?? 0
                    print("\(oppid)-=-=-=")
                    self.celldelegate?.SeeDetails(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
            }
            if txt == "Like"{
                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                opppreid = oppid ?? 0
                print("\(oppid)-=-=-=")
                
                self.globalApi.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike,sucess  in
                    obj.likes = Int.getInt(countLike)
                    debugPrint("Int.getInt(countLike)",Int.getInt(countLike))
                    cell.lblLikeCount.text = String.getString(obj.likes) //+ " " + "likes"
                    
                    if sucess == 200{
                        cell.imglike.image = UIImage(named: "dil")
                    }
                    else if sucess == 400{
                        cell.imglike.image = UIImage(named: "unlike")
                    }
                }
            }
            if txt == "More" {
                
                if UserData.shared.id == Int.getInt(obj.user_id){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ProileSocialMoreVC.getStoryboardID()) as! ProileSocialMoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callback = { txt in
                        
                        if txt == "Dismiss"{
                            self.dismiss(animated: true)
                            //   self.listoppoertunityapi()
                        }
                        
                        if txt == "CopyLink"{
                            let share_link = String.getString(userTimeLine[indexPath.row].share_link)
                            UIPasteboard.general.string = share_link
                            print("share_link\(share_link)")
                            if kSharedUserDefaults.getlanguage() as? String == "en"{
                                CommonUtils.showError(.info, String.getString("Link Copied"))
                            }
                            else{
                                CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
                            }
                        }
                        
                        if txt == "Update"{
                            let oppid = Int.getInt(userTimeLine[indexPath.row].id)
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
                                            let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                            userTimeLine.remove(at: indexPath.row)
                                            self.deletepostoppoertunityapi(oppr_id: oppid)
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
                                            let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                                            self.closeopportunityapi(opr_id: oppid ?? 0) { sucess in
                                                if sucess == 200 {
                                                    cell.lblcloseOpportunity.text = "Closed"
                                                    cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
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
                            if UserData.shared.isskiplogin == true{
                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                }
                                else{
                                    self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                                }
                                
                            }
                            else{
                                let userid = Int.getInt(userTimeLine[indexPath.row].user_id)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                                vc.friendid = userid
                                vc.friendname = String.getString(obj.userdetail?.name)
                                vc.friendimage = imguserurl
                                self.navigationController?.pushViewController(vc, animated: true)
                                self.dismiss(animated: true)
                            }
                        }
                        if txt == "CopyLink"{
                            let share_link = String.getString(userTimeLine[indexPath.row].share_link)
                            UIPasteboard.general.string = share_link
                            print("share_link\(share_link)")
                            if kSharedUserDefaults.getlanguage() as? String == "en"{
                                CommonUtils.showError(.info, String.getString("Link Copied"))
                            }
                            else{
                                CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
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
                                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
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
                                    let oppid = Int.getInt(userTimeLine[indexPath.row].id)
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
                                    let userid = Int.getInt(userTimeLine[indexPath.row].user_id)
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
                                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
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
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  15
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: 320)
//        return CGSize(width: 200, height: 298)
    }
}

//    MARK: - Api Call -

extension SocialPostTVC{
    
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
                        
                        self.SocialPostCV.reloadData()
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
}
