//  DetailScreenVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 25/08/22.

import UIKit
import StripeUICore

class DetailScreenVC: UIViewController,DocumentCollectionViewCellDelegate{
    
    lazy var globalApi  = {
        GlobalApi()
    }()
    
    @IBOutlet weak var tblviewDetail: UITableView!
    @IBOutlet weak var lblDetailScreen: UILabel!
    
    var docUrl = ""
    var imgUrl = ""
    var UserTimeLineOppdetails:SocialPostData?
    var userTimeLine: SocialPostData?
    //  var img = [oppr_image]()
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
        
        self.navigationController?.popViewController(animated: true)
        
        // kSharedAppDelegate?.makeRootViewController()
    }
}

extension DetailScreenVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.userTimeLine?.usercomment.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
            
        }
        else{
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
            
            //            let imgurl = URL(string: String.getString(obj?.image))
            //            view.labelImage.sd_setImage(with: imgurl)
            view.labelImage.downlodeImage(serviceurl: obj?.image ?? "" , placeHolder: UIImage(named: "Boss"))
            
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
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Please add reply")
                        }
                        else{
                            self.showSimpleAlert(message: "الرجاء إضافة الرد")
                        }
                        
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
            
            //  cell.viewLine.isHidden = true
            //  cell.SocialPostCollectionView.tag = indexPath.section
            //  cell.DocumentCollectionView.tag = indexPath.section
            cell.celldelegate = self
            cell.lblUserName.text = String.getString(self.userTimeLine?.userdetail?.name)
            cell.lblDescribtion.text = String.getString(self.userTimeLine?.description)
            cell.lblTitle.text = String.getString(self.userTimeLine?.title)
            cell.lblpricing.text = String.getString(self.userTimeLine?.pricing)
            cell.lblposted.text =  String(String.getString(self.userTimeLine?.created_at).prefix(10))
            cell.lblClosed.text = String(String.getString(self.userTimeLine?.close_opr_date).prefix(10))
            cell.lblCommentCout.text = String.getString(Int.getInt(self.userTimeLine?.commentsCount))
            cell.viewAddComment.isHidden = self.userTimeLine?.isComment == false ? true : false
            cell.heightAddComment.constant = self.userTimeLine?.isComment == false ? 0 : 55
            //  cell.heightViewAddComment.constant = self.userTimeLine?.isComment == false ? 0 : 55
            
            if UserData.shared.user_type == "0"{// Investor
                if kSharedUserDefaults.getpayment_type() as? String == "Basic Plan"{
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
                else if kSharedUserDefaults.getpayment_type() as? String == "Silver Plan"{
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
                
                else if kSharedUserDefaults.getpayment_type() as? String == "Gold Plan"{
                    cell.lblEmail.text = String.getString(self.userTimeLine?.userdetail?.email)
                    cell.llbMobileNumber.text =  String.getString(self.userTimeLine?.mobile_num)
                    cell.DocumentCollectionView.isHidden = false
                    cell.heightDocumentcollectionview.constant = self.userTimeLine?.oppdocument.count == 0 ? 0 : 60
                    
                    if String.getString(self.userTimeLine?.location_name) != ""{
                        cell.lblLocationName.text = String.getString(self.userTimeLine?.location_name)
                        cell.lblLocationName.textColor = UIColor.black
                    }
                    else{
                        cell.lblLocationName.text = "Location not available"
                        cell.lblLocationName.textColor = UIColor.gray
                    }
                    if String.getString(self.userTimeLine?.whatsaap_num) != ""{
                        cell.lbblWhatsappNumber.text = String.getString(self.userTimeLine?.whatsaap_num)
                        cell.lbblWhatsappNumber.textColor = UIColor.black
                    }
                    else{
                        cell.lbblWhatsappNumber.text = "Not available"
                        cell.lbblWhatsappNumber.textColor = UIColor.gray
                    }
                }
            }
            
            else{
                
                cell.lblEmail.text = String.getString(self.userTimeLine?.userdetail?.email)
                cell.llbMobileNumber.text =  String.getString(self.userTimeLine?.mobile_num)
                cell.heightDocumentcollectionview.constant = self.userTimeLine?.oppdocument.count == 0 ? 0 : 60
                if String.getString(self.userTimeLine?.location_name) != ""{
                    cell.lblLocationName.text = String.getString(self.userTimeLine?.location_name)
                    cell.lblLocationName.textColor = UIColor.black
                }
                else{
                    cell.lblLocationName.text = "Location not available"
                    cell.lblLocationName.textColor = UIColor.gray
                }
                if String.getString(self.userTimeLine?.whatsaap_num) != ""{
                    cell.lbblWhatsappNumber.text = String.getString(self.userTimeLine?.whatsaap_num)
                    cell.lbblWhatsappNumber.textColor = UIColor.black
                }
                else{
                    cell.lbblWhatsappNumber.text = "Not available"
                    cell.lbblWhatsappNumber.textColor = UIColor.gray
                }
            }
            cell.lblCategoryName.text = String.getString(self.userTimeLine?.category_name)
            cell.lblCategory.text = String.getString(self.userTimeLine?.category_name)
            cell.lblSub_category.text = String.getString(self.userTimeLine?.sub_category_name)
            
            if UserData.shared.id == self.userTimeLine?.user_id{
                //                cell.btnChat.isHidden = true
                cell.viewSave.isHidden = true
            }
            else{
                //                cell.btnChat.isHidden = false
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
            
            cell.lblRating.text = String.getString(self.userTimeLine?.opr_rating)
            cell.imgOpp_plan.image = self.userTimeLine?.opp_plan == "Featured" ? UIImage(named: "Star Filled") : self.userTimeLine?.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "Folded Booklet")
            
            if String.getString(self.userTimeLine?.looking_for) == "0"{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblLookingFor.text = "Looking for Investor"
                }
                else{
                    cell.lblLookingFor.text = "تبحث عن مستثمر"
                }
            }
            else if String.getString(self.userTimeLine?.looking_for) == "1"{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblLookingFor.text = "Looking for Business Owner"
                }
                else{
                    cell.lblLookingFor.text = "أبحث عن صاحب عمل"
                }
            }
            else if String.getString(self.userTimeLine?.looking_for) == "2"{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblLookingFor.text = "Looking for Service Provider"
                }
                else{
                    cell.lblLookingFor.text = "أبحث عن مزود الخدمة"
                }
            }
            
            if String.getString(self.userTimeLine?.location_map) != ""{
                cell.lblLocationONMap.text = String.getString(self.userTimeLine?.location_map)
                cell.lblLocationONMap.textColor = UIColor.black
            }
            
            else{
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblLocationONMap.text = "Location on map not available"
                }
                else{
                    cell.lblLocationONMap.text = "الموقع على الخريطة غير متوفر"
                }
                
                cell.lblLocationONMap.textColor = UIColor.gray
            }
            
            if String.getString(self.userTimeLine?.plan_name) == "Basic Plan"{
                //                cell.lblLocationONMap.text = "Not for basic Plan"
                //                cell.lblLocationONMap.textColor = UIColor.gray
                //                cell.lbblWhatsappNumber.text = "Not for basic Plan"
                //                cell.lbblWhatsappNumber.textColor = UIColor.gray
                //                cell.llbMobileNumber.text = "Not for basic Plan"
                //                cell.llbMobileNumber.textColor = UIColor.gray
                //                cell.DocumentCollectionView.isHidden = true
                //                cell.lblEmail.text = "Not for basic Plan"
                //                cell.lblEmail.textColor = UIColor.gray
                //                cell.heightDocumentcollectionview.constant = 0
            }
            
            else if String.getString(self.userTimeLine?.plan_name) == "Silver Plan"{
                //                cell.lblLocationONMap.text = "Not for Silver Plan"
                //                cell.lblLocationONMap.textColor = UIColor.gray
                //                cell.lbblWhatsappNumber.text = "Not for Silver Plan"
                //                cell.lbblWhatsappNumber.textColor = UIColor.gray
                //                cell.llbMobileNumber.text = "Not for Silver Plan"
                //                cell.llbMobileNumber.textColor = UIColor.gray
                //                cell.DocumentCollectionView.isHidden = true
                //                cell.lblEmail.text = "Not forSilver Plan"
                //                cell.lblEmail.textColor = UIColor.gray
                //                cell.heightDocumentcollectionview.constant = 0
            }
            
            let imguserurl = String.getString(self.userTimeLine?.userdetail?.image)
            debugPrint("socialprofile......",imguserurl)
            cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
            cell.img = self.userTimeLine?.oppimage ?? [] // Collection View k liye image pass kr rhe
            cell.imgUrl = self.imgUrl
            cell.doc = self.userTimeLine?.oppdocument ?? [] // Pass Doc for collection view
            
            cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes)// + " " + "Likes"
            
            if String.getString(self.userTimeLine?.is_user_like) == "1"{
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
            if Int.getInt(self.userTimeLine?.is_saved) == 1{
                cell.imgsave.image = UIImage(named: "saveopr")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblSave.text = "Saved"
                }
                else{
                    cell.lbllike.text = "تم الحفظ"
                }
                
                cell.lblSave.textColor = UIColor(hexString: "#1572A1")
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                if kSharedUserDefaults.getlanguage() as? String == "en"{
                    cell.lblSave.text = "Save"
                }
                else{
                    cell.lbllike.text = "يحفظ"
                }
                
                cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
            }
            
            if String.getString(self.userTimeLine?.is_flag) == "1"{
                cell.imgOppFlag.isHidden = false
            }
            else{
                cell.imgOppFlag.isHidden = true
                cell.WidthViewFlag.constant = 30
            }
            
            if Int.getInt(self.userTimeLine?.close_opr) == 0{
                cell.lblTitle.textColor = .black
                cell.lblcloseOpportunity.text = "Available"
                cell.lblcloseOpportunity.textColor = UIColor(hexString: "#20D273")
            }
            else {
                cell.lblcloseOpportunity.text = "Closed"
                cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
            }
            
            cell.heightSocialPostCollectionView.constant = 275
            //            cell.viewSeeDetails.isHidden = true
            //            cell.btnViewDetails.isHidden = true
            
            cell.callback = { txt, tapped in
                
                if txt == "LikeCount"{
                    let oppid = Int.getInt(self.userTimeLine?.id)
                    let likecount = String.getString(self.userTimeLine?.likes)
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LikelistVC") as! LikelistVC
                    
                    if #available(iOS 15.0, *) {
                        if let presentationController = vc.presentationController as? UISheetPresentationController {
                            presentationController.detents = [.medium(), .large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    vc.oppr_id = oppid
                    vc.likecount = likecount
                    self.present(vc, animated: true)
                }
                
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
                    let oppid = Int.getInt(self.userTimeLine?.id)
                    debugPrint("oppid--=-=-=-",oppid)
                    
                    self.globalApi.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike,sucess  in
                        self.userTimeLine?.likes = Int.getInt(countLike)
                        debugPrint("Int.getInt(countLike)",Int.getInt(countLike))
                        cell.lblLikeCount.text = String.getString(self.userTimeLine?.likes) // + " " + "likes"
                        
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
                
                if txt == "Share" {
                    let image = String.getString(self.userTimeLine?.share_link)
                    let imageShare = [ image ]
                    let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
                
                if txt == "Save"{
                    if tapped.isSelected{
                        //   if String.getString(self.userTimeLine?.is_saved) == "0"{
                        let oppid = Int.getInt(self.userTimeLine?.id)
                        self.globalApi.saveoppoertunityapi(oppr_id: oppid ?? 0) { sucess in
                            if sucess == 200{
                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                    cell.lblSave.text = "Saved"
                                }
                                else{
                                    cell.lblSave.text = "تم الحفظ"
                                }
                                cell.lblSave.textColor = UIColor(hexString: "#1572A1")
                                cell.imgsave.image = UIImage(named: "saveopr")
                            }
                            else if sucess == 400{
                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                    cell.lblSave.text = "Save"
                                }
                                else{
                                    cell.lblSave.text = "يحفظ"
                                }
                                cell.imgsave.image = UIImage(named: "save-3")
                                cell.lblSave.textColor = UIColor(hexString: "#A6A6A6")
                            }
                        }
                    }
                }
                
                if txt == "More" {
                    let obj = self.userTimeLine
                    if UserData.shared.id == Int.getInt(obj?.user_id){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: ProileSocialMoreVC.getStoryboardID()) as! ProileSocialMoreVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.hascamefrom = "DetailPage"
                        vc.callback = { txt in
                            
                            if txt == "Dismiss"{
                                self.dismiss(animated: true)
                                //      self.listoppoertunityapi()
                            }
                            
                            if txt == "CopyLink"{
                                let share_link = String.getString(self.userTimeLine?.share_link)
                                UIPasteboard.general.string = share_link
                                print("share_link\(share_link)")
                                //                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                //                                    CommonUtils.showError(.info, String.getString("Link Copied"))
                                //                                }
                                //                                else{
                                //                                    CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
                                //                                }
                            }
                            
                            if txt == "Update"{
                                let oppid = Int.getInt(self.userTimeLine?.id)
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
                                                let oppid = Int.getInt(self.userTimeLine?.id)
                                                // self.userTimeLine.remove(at: indexPath.row)
                                                self.globalApi.deletepostoppoertunityapi(oppr_id: oppid)
                                                debugPrint("oppid......",oppid)
                                                //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
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
                                                let oppid = Int.getInt(self.userTimeLine?.id)
                                                self.globalApi.closeopportunityapi(opr_id: oppid){ sucess in
                                                    if sucess == 200{
                                                        cell.lblcloseOpportunity.text = "Closed"
                                                        cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
                                                    }
                                                    
                                                }
                                                debugPrint("oppidclose......",oppid)
                                            }
                                        }
                                    }
                                    self.present(vc, animated: false)
                                }
                            }
                        }
                        self.present(vc, animated: false)
                    }
                    
                    else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.hascamefrom = "DetailPage"
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
                                    let userid = Int.getInt(self.userTimeLine?.user_id)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                                    vc.friendid = userid
                                    vc.friendname = String.getString(obj?.userdetail?.name)
                                    vc.friendimage = imguserurl
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    self.dismiss(animated: true)
                                }
                            }
                            if txt == "CopyLink"{
                                let share_link = String.getString(self.userTimeLine?.share_link)
                                UIPasteboard.general.string = share_link
                                print("share_link\(share_link)")
                                //                                if kSharedUserDefaults.getlanguage() as? String == "en"{
                                //                                    CommonUtils.showError(.info, String.getString("Link Copied"))
                                //                                }
                                //                                else{
                                //                                    CommonUtils.showError(.info, String.getString("تم نسخ الرابط"))
                                //                                }
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
                                    let oppid = Int.getInt(self.userTimeLine?.id)
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
                                        let oppid = Int.getInt(self.userTimeLine?.id)
                                        vc.oppid = oppid
                                        self.present(vc, animated: false)
                                        vc.callbackClosure = {
                                            self.getalldetail()
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
                                        let oppid = Int.getInt(self.userTimeLine?.user_id)
                                        vc.userid = oppid
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
                                    let oppid = Int.getInt(self.userTimeLine?.id)
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
                        if kSharedUserDefaults.getlanguage() as? String == "en"{
                            self.showSimpleAlert(message: "Please add comment")
                        }
                        else{
                            self.showSimpleAlert(message: "الرجاء إضافة تعليق")
                        }
                        
                    }
                    else{
                        self.commentoppoertunityapi(oppr_id: Int.getInt(self.userTimeLine?.id) ?? 0) { userComment in
                            cell.txtviewComment.text = ""
                            
                            let cell = self.tblviewDetail.dequeueReusableCell(withIdentifier: "SeeMoreCommentCell") as! SeeMoreCommentCell
                            
                            cell.lblNameandComment.text = String.getString(userComment.first?.name) + " " + String.getString(userComment.first?.comments)
                            
                            debugPrint("lblcommentName====-", cell.lblNameandComment.text )
                            
                            let imgcommentuserurl = String.getString(userComment.first?.image)
                            let imgurl = URL(string: imgcommentuserurl)
                            debugPrint("commentuserprofile......",imgcommentuserurl)
                            cell.imgCommentUser.sd_setImage(with: imgurl, placeholderImage:UIImage(named: "Boss"))
                            
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
    
    func collectionView(collectionviewcell: DocumentCollectionViewCell?, index: Int, didTappedInTableViewCell: DetailsTableViewCell) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentWebView") as! DocumentWebView
        vc.doclink = doc_url
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    //  Api Detail Opportunity
    
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
                        
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.tblviewDetail.reloadData()
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
                //      CommonUtils.showToastForDefaultError()
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
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kcommentreply, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                //  CommonUtils.showToastForDefaultError()
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
                //       CommonUtils.showToastForDefaultError()
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
            //       "user_id":Int.getInt(UserData.shared.id),
            "opr_id":oppr_id
        ]
        
        debugPrint("opr_id......",oppr_id)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kflagpost, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                //        CommonUtils.showToastForDefaultError()
            }
        }
    }
}

extension DetailScreenVC{
    func setuplanguage(){
        lblDetailScreen.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Detail Screen", comment: "")
    }
}
