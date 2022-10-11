//
//  ProfileVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 20/06/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgNoOpp: UIImageView!
    
    var oppid:Int?
    var imgUrl = ""
    var docUrl = ""
    var isProfileImageSelected = false
    var userImage:String?
    var datadashboard:data_dashboard?
    var userTimeLine = [SocialPostData]() //Array
    var UserTimeLineOppdetails:SocialPostData? // Dictionary m hai
    var comment = [user_comment]()
    var txtcomment = ""
    var isbtnAllSelect = false
    var isbtnPremiumSelect = false
    var isbtnFeaturedSelect = false
    
    
    @IBOutlet weak var tblViewSocialPost: UITableView!
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgNoOpp.isHidden = true
        
        //        self.listoppoertunityapi()
        tblViewSocialPost.register(UINib(nibName: "OpportunitypostedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OpportunitypostedTableViewCell")
        tblViewSocialPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        
        
        
        if UserData.shared.isskiplogin == true{
            print("Guest User")
            self.lblMobileNumber.isHidden = true
            self.lblEmail.isHidden = true
            self.imgNoOpp.isHidden = false
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
        
        
        if let url = URL(string: "\("https://demo4esl.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
            debugPrint("urlimage...",  url)
            
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
    
    
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        
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
                                //                                self.logout()
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
            
            if UserData.shared.isskiplogin == true{
                cell.imgOppPosted.isHidden = true
            }
            else{
                if UserData.shared.user_type == "0"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.expiry_date)
                    cell.lblDate.text = "Expiration Date"
                    cell.lblshowplan.text = String.getString(self.datadashboard?.plan_type)
                    cell.lblPlan.text = "Subscription Plan"
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_saved)
                    cell.lblOpportunity.text = "Saved Opportunity"
                }
                else if UserData.shared.user_type == "1"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.total_create)
                    cell.lblDate.text = "Total Create"
                    cell.lblshowplan.text = String.getString(self.datadashboard?.no_view)
                    cell.lblPlan.text = "Total views"
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_flag)
                    cell.lblOpportunity.text = "Flagged Opportunities"
                    
                }
                else if UserData.shared.user_type == "2"{
                    cell.lblshowdata.text = String.getString(self.datadashboard?.total_create)
                    cell.lblDate.text = "Total Create"
                    cell.lblshowplan.text = String.getString(self.datadashboard?.no_view)
                    cell.lblPlan.text = "Total views"
                    cell.lblshowOpportunity.text = String.getString(self.datadashboard?.no_flag)
                    cell.lblOpportunity.text = "Flagged Opportunities"
                    
                }
            }
            cell.callbackbtnSelect = { txt in
                if txt == "All"{
                    if UserData.shared.isskiplogin == true{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        self.imgNoOpp.isHidden = false
                    }
                    else{
                        self.isbtnAllSelect  = true
                        self.listoppoertunityapi()
                    }
                    
                }
                if txt == "Premium"{
                    if UserData.shared.isskiplogin == true{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        self.imgNoOpp.isHidden = false
                    }
                    else{
                        self.isbtnPremiumSelect = true
                        self.getallpremiumapi()
                    }
                    
                }
                if txt == "Featured"{
                    if UserData.shared.isskiplogin == true{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                        self.imgNoOpp.isHidden = false
                    }
                    else{
                        self.isbtnFeaturedSelect = true
                        self.getallFeaturedapi()
                    }
                    
                }
                
            }
            return cell
            
        case 1:
            let cell = self.tblViewSocialPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            cell.SocialPostCollectionView.tag = indexPath.section
            
            let profilrimageurl = "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"
            
            let obj = userTimeLine[indexPath.row]
            
            cell.lblUserName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.lblRating.text = String.getString(obj.opr_rating)
            
            
            
            cell.Imageuser.downlodeImage(serviceurl: profilrimageurl, placeHolder: UIImage(named: "Boss"))
            print("-=-opp_plan=-=-\(String.getString(obj.opp_plan))")
            
            cell.imgOpp_plan.image = obj.opp_plan == "Featured" ? UIImage(named: "Star Filled") : obj.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "Folded Booklet")
            
            
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "Likes"
            
            
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
            
            
            cell.callback = { txt, tapped in
                
                if txt == "Profileimage"{
                    let user_id = self.userTimeLine[indexPath.row].user_id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: UserProfileDetailsVC.getStoryboardID()) as! UserProfileDetailsVC
                    vc.userid = user_id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                if txt == "Like"{
                    let oppid = self.userTimeLine[indexPath.row].id
                    debugPrint("oppid--=-=-=-",oppid)
                    //                            self.likeOpportunityapi(oppr_id: oppid ?? 0)
                    self.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike in
                        obj.likes = Int.getInt(countLike)
                        cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
                    }
                    cell.imglike.image = UIImage(named: "dil")
                    cell.lbllike.text = "Liked"
                }
                
                if txt == "Rate"{
                    let oppid = self.userTimeLine[indexPath.row].id
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: RateOpportunityPopUPVC.getStoryboardID()) as! RateOpportunityPopUPVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.oppid = oppid ?? 0
                    
                    vc.callbackClosure = {
                        
                        if self.isbtnAllSelect == true{
                            self.listoppoertunityapi()
                        }
                        else if self.isbtnPremiumSelect == true{
                            self.getallpremiumapi()
                        }
                        else if self.isbtnFeaturedSelect == true{
                            self.getallFeaturedapi()
                        }
                        else{
                            self.listoppoertunityapi()
                        }
                        
                    }
                    self.present(vc, animated: false)
                    
                }
                
                if txt == "Save"{
                    if tapped.isSelected{
                        
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ProileSocialMoreVC.getStoryboardID()) as! ProileSocialMoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callback = { txt in
                        
                        if txt == "Dismiss"{
                            self.dismiss(animated: true)
                            //                        self.listoppoertunityapi()
                        }
                        
                        if txt == "Update"{
                            
                            let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                            
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
                                            debugPrint("oppidclose......",oppid)
                                            
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
                    if tapped.isSelected{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewSocialPost.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewSocialPost.reloadData()
                        }
                    }else{
                        if obj.isComment == false{
                            obj.isComment = true
                            self.tblViewSocialPost.reloadData()
                        }
                        else{
                            obj.isComment = false
                            self.tblViewSocialPost.reloadData()
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
                            
                            self.listoppoertunityapi()
                            
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
            
            
            
            cell.callbacktextviewcomment = {[weak tblViewSocialPost] (_) in
                
                self.txtcomment = cell.txtviewComment.text
                self.tblViewSocialPost?.beginUpdates()
                self.tblViewSocialPost?.endUpdates()
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
    
    // Api Dashboard
    
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
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kdashboard, requestMethod: .POST,
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
                        
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        self?.datadashboard = data_dashboard(data: data)
                        
                        print("Datadashboard====-=\(self?.datadashboard)")
                        
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblViewSocialPost.reloadData()
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
                CommonUtils.showToastForDefaultError()
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
                        
                        print("DataAllPost====-=\(self?.userTimeLine)")
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblViewSocialPost.reloadData()
                        CommonUtils.showHudWithNoInteraction(show: false)
                        self?.imgNoOpp.isHidden = true
                        
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
                CommonUtils.showToastForDefaultError()
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
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        
                        print("DataAllPost====-=\(self?.userTimeLine)")
                        
                        self?.tblViewSocialPost.reloadData()
                        self?.imgNoOpp.isHidden = true
                        
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
                CommonUtils.showToastForDefaultError()
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
                        
                        print("DataAllPost====-=\(self?.userTimeLine)")
                        
                        
                        self?.tblViewSocialPost.reloadData()
                        self?.imgNoOpp.isHidden = true
                        
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

