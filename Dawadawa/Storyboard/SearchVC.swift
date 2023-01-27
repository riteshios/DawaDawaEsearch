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
        txtfieldSearch.returnKeyType = .search
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
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]
            
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            debugPrint("username.....", cell.lblUserName.text)
            cell.lblTitle.text = String.getString(obj.title)
//            cell.lblDescribtion.text = String.getString(obj.description)
            cell.lblRating.text = String.getString(obj.opr_rating)
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            let imguserurl = String.getString(obj.userdetail?.social_profile)
            debugPrint("socialprofile......",imguserurl)
            
            cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
            
            cell.lblLikeCount.text = String.getString(obj.likes) //+ " " + "Likes"
            
            cell.imgOpp_plan.image = obj.opp_plan == "Featured" ? UIImage(named: "Star Filled") : obj.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "Folded Booklet")
            
            
            if Int.getInt(obj.close_opr) == 0{
                cell.lblTitle.text = String.getString(obj.title)
                cell.lblTitle.textColor = .black
                cell.lblcloseOpportunity.text = "Available"
                cell.lblcloseOpportunity.textColor = UIColor(hexString: "#20D273")
            }
            else{
                cell.lblcloseOpportunity.text = "Closed"
                cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
            }
            
            if String.getString(obj.is_user_like) == "1"{
                cell.imglike.image = UIImage(named: "dil")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lbllike.text = "Liked"
                }
                else{
                    cell.lbllike.text = "احب"
                }
                
                cell.lbllike.textColor = .red
            }
            else{
                cell.imglike.image = UIImage(named: "unlike")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lbllike.text = "Like"
                }
                else{
                    cell.lbllike.text = "مثل"
                }
                cell.lbllike.textColor = UIColor(hexString: "#A6A6A6")
            }
            
            if String.getString(obj.is_saved) == "1"{
                cell.imgsave.image = UIImage(named: "saveopr")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblSave.text = "Saved"
                }
                else{
                    cell.lblSave.text = "تم الحفظ"
                }
                cell.lblSave.textColor = UIColor(hexString: "#1572A1")
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblSave.text = "Save"
                }
                else{
                    cell.lblSave.text = "يحفظ"
                }
                cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
            }
            
            if String.getString(obj.is_flag) == "1"{
                cell.imgOppFlag.isHidden = false
                cell.LeadingOppType.constant = 17
            
            }
            else{
                cell.imgOppFlag.isHidden = true
                cell.LeadingOppType.constant = -20
            }
            
//            if obj.oppimage.count == 0{
//                cell.heightSocialPostCollectionView.constant = 0
//            }
//            else{
//                cell.heightSocialPostCollectionView.constant = 225
//            }
            
            if String.getString(obj.opr_rating) == ""{
                cell.lblRating.text = "0.0"
            }
            else{
                cell.lblRating.text = String.getString(obj.opr_rating)
            }
            
            if UserData.shared.id == Int.getInt(obj.user_id){
                cell.btnChat.isHidden = true
                cell.viewSave.isHidden = true
            }
            else{
                cell.btnChat.isHidden = false
                cell.viewSave.isHidden = false
            }
            
            cell.callback = { txt, sender in
                
                if txt == "Chat"{
                    let userid = Int.getInt(self.userTimeLine[indexPath.row].user_id)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                    vc.friendid = userid
                    vc.friendname = String.getString(obj.userdetail?.name)
                    vc.friendimage = imguserurl
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if txt == "viewDetails"{
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "viewDetails2"{
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Description"{
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("detailsppid=-=-=",oppid)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailScreenVC.getStoryboardID()) as! DetailScreenVC
                    vc.oppid = oppid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Profileimage"{
                    let user_id = self.userTimeLine[indexPath.row].user_id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = user_id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if txt == "Like"{
                    if UserData.shared.isskiplogin == true{
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        }
                        else{
                            self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                        }
                    }
                    else{
                        let oppid = self.userTimeLine[indexPath.row].id
                        debugPrint("oppid--=-=-=-",oppid)
                        
                        self.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike,sucess  in
                            obj.likes = Int.getInt(countLike)
                            debugPrint("Int.getInt(countLike)",Int.getInt(countLike))
                            cell.lblLikeCount.text = String.getString(obj.likes) //+ " " + "likes"
                            
                            if sucess == 200{
                                cell.imglike.image = UIImage(named: "dil")
                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                    cell.lbllike.text = "Liked"
                                }
                                else{
                                    cell.lbllike.text = "احب"
                                }
                                cell.lbllike.textColor = .red
                            }
                            else if sucess == 400{
                                cell.imglike.image = UIImage(named: "unlike")
                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                    cell.lbllike.text = "Like"
                                }
                                else{
                                    cell.lbllike.text = "مثل"
                                }
                                cell.lbllike.textColor = UIColor(hexString: "#A6A6A6")
                            }
                        }
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
                            if kSharedUserDefaults.getlanguage() as? String == "en"{
                                cell.lblSave.text = "Saved"
                            }
                            else{
                                cell.lblSave.text = "تم الحفظ"
                            }
                            cell.lblSave.textColor = UIColor(hexString: "#1572A1")
                        }
                        else{
                            let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                            self.unsaveoppoertunityapi(oppr_id: oppid)
                            cell.imgsave.image = UIImage(named: "save-3")
                            if kSharedUserDefaults.getlanguage() as? String == "en"{
                                cell.lblSave.text = "Save"
                            }
                            else{
                                cell.lblSave.text = "يحفظ"
                            }
                            cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
                        }
                    }
                    else{
                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                        self.unsaveoppoertunityapi(oppr_id: oppid)
                        cell.imgsave.image = UIImage(named: "save-3")
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            cell.lblSave.text = "Save"
                        }
                        else{
                            cell.lblSave.text = "يحفظ"
                        }
                        cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
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
                                    if kSharedUserDefaults.getlanguage() as? String == "en"{
                                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                                    }
                                    else{
                                        self.showSimpleAlert(message: "غير متاح للمستخدم الضيف يرجى التسجيل للوصول الكامل")
                                    }
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
                            
                            if txt == "Chatwithuser"{
                                
                                let userid = Int.getInt(self.userTimeLine[indexPath.row].user_id)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                                vc.friendid = userid
                                vc.friendname = String.getString(obj.userdetail?.name)
                                vc.friendimage = imguserurl
                                self.navigationController?.pushViewController(vc, animated: true)
                                self.dismiss(animated: true)
                            }
                            if txt == "CopyLink"{
                                let share_link = String.getString(self.userTimeLine[indexPath.row].share_link)
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
                                let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                self.markinterestedapi(oppr_id: oppid)
                                self.dismiss(animated: true)
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
                                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                        vc.oppid = oppid
                                        self.present(vc, animated: false)
                                        vc.callbackClosure = {
                                            self.searchopportunityapi()
                                        }
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
                                        let userid = Int.getInt(self.userTimeLine[indexPath.row].user_id)
                                        vc.userid = userid
                                        self.present(vc, animated: false)
                                    }
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
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Please add comment ")
                        }
                        else{
                            self.showSimpleAlert(message: "الرجاء إضافة تعليق")
                        }
                        
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
                if txt == "Iconusercomment" {
                    let userid = Int.getInt(self.userTimeLine[indexPath.row].usercomment.first?.user_id) ?? 0
                    print("SelfICON\(userid)")
                    print("selfuserid\(UserData.shared.id)")
                    
                    if UserData.shared.id == userid{
                        print("Self")
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                        vc.userid = userid
                        vc.friendname = String.getString(self.userTimeLine[indexPath.row].usercomment.first?.name)
                        vc.friendimage = String.getString(self.userTimeLine[indexPath.row].usercomment.first?.image)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if txt == "IconuserSubcomment"{
                    let userid = Int.getInt(self.userTimeLine[indexPath.row].usercomment.first?.subcomment.first?.usersubcommentdetails?.id) ?? 0
                    if UserData.shared.id == userid{
                        print("Self")
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                        vc.userid = userid
                        vc.friendname = String.getString(self.userTimeLine[indexPath.row].usercomment.first?.subcomment.first?.usersubcommentdetails?.name)
                        vc.friendimage = String.getString(obj.usercomment.first?.subcomment.first?.usersubcommentdetails?.image)
                        self.navigationController?.pushViewController(vc, animated: true)
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
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    //    Api like Opportunity
    
    func likeOpportunityapi(oppr_id:Int,completion: @escaping(_ countLike: String,_ Sucesscode: Int)->Void){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.klikeopportunity, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                        
                        //     self?.count = String.getString(dictResult["count"])
                        //     debugPrint("likecount=-=-=-=",self?.count)
                        completion(String.getString(dictResult["count"]),Int.getInt(dictResult["status"]))
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        completion(String.getString(dictResult["count"]), Int.getInt(dictResult["status"]))
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            CommonUtils.showError(.info, String.getString("This Opportunity is unlike by You"))
                        }
                        else{
                            CommonUtils.showError(.info, String.getString("هذه الفرصة تختلف عنك"))
                        }
                        //         CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
                        //    CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksaveOpp, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                //                CommonUtils.showToastForDefaultError()
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kunsavedopp, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                //                CommonUtils.showToastForDefaultError()
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
                //                CommonUtils.showToastForDefaultError()
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
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestsearchopportunity, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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

extension SearchVC{
    func setuplanguage(){
        txtfieldSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search opportunities", comment: "")
    }
}
