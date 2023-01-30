//  SocialPostTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 20/07/22.

import UIKit
import IQKeyboardManagerSwift

class SocialPostTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    var callback:((String, UIButton)->())?
    var callbacktextviewcomment: ((String) -> Void)?
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
   
    @IBOutlet weak var lblcloseOpportunity: UILabel!
    @IBOutlet weak var Imageuser: UIImageView!
    @IBOutlet weak var imgredCircle: UIImageView!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var imgOpp_plan: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var lbllike: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    
    @IBOutlet weak var imgsave: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var WidthViewRating: NSLayoutConstraint!
    
    @IBOutlet weak var heightSocialPostCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var imgOppFlag: UIImageView!
    @IBOutlet weak var btnProfileimage: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnviewDetails: UIButton!
    @IBOutlet weak var btnDescription: UIButton!
    @IBOutlet weak var LeadingOppType: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewSave: UIView!
    
    //    Comment Section
    
    @IBOutlet weak var btnClickComment: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var txtviewComment: IQTextView!
    @IBOutlet weak var imageCommentUser: UIImageView!
    @IBOutlet weak var lblusernameandcomment: UILabel!
    @IBOutlet weak var imageSubcommentUser: UIImageView!
    @IBOutlet weak var lblsubUserNameandComment: UILabel!
    @IBOutlet weak var viewAddComment: UIView!
    @IBOutlet weak var viewcomment: UIView!
    @IBOutlet weak var verticalSpacingReply: NSLayoutConstraint!
    @IBOutlet weak var bottomspacingReply: NSLayoutConstraint!
    
    @IBOutlet weak var VerticalspacingSubComment: NSLayoutConstraint!
    @IBOutlet weak var heightViewAddComment: NSLayoutConstraint!
    @IBOutlet weak var heightViewComment: NSLayoutConstraint!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnSeemoreComment: UIButton!
    @IBOutlet weak var btnUserComment: UIButton!
    @IBOutlet weak var btnUserSubComment: UIButton!
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var liked = 0
    var img = [oppr_image](){
        didSet{
            pageControl.isHidden = true
            pageControl.numberOfPages = img.count
            self.SocialPostCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        SocialPostCollectionView.delegate = self
        SocialPostCollectionView.dataSource = self
        SocialPostCollectionView.register(UINib(nibName: "SocialPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialPostCollectionViewCell")
        pageControl.numberOfPages = img.count
        pageControl.currentPage = 0
        
        self.txtviewComment.delegate = self
        self.viewAddComment.isHidden = true
        self.viewcomment.isHidden = true
        self.heightViewAddComment.constant = 0
        self.heightViewComment.constant = 0
        self.imageSubcommentUser.isHidden = true
        self.lblsubUserNameandComment.isHidden = true
        self.imgOppFlag.isHidden = true
//        self.imgredCircle.isHidden = true
//        self.lblcloseOpportunity.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.callbacktextviewcomment = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        callbacktextviewcomment?(textView.text)
    }
    
    //    MARK: - @IBAction
    
    
    @IBAction func btnProfileImageTapped(_ sender: UIButton) {
        self.callback?("Profileimage",sender)
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callback?("More", sender)
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Like", sender)
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        self.callback?("Share", sender)
    }
    
    @IBAction func btnRateTapped(_ sender: UIButton) {
        self.callback?("Rate",sender)
    }
    
    @IBAction func btnSavedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Save", sender)
    }
    
    @IBAction func btnClickCommentBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("ClickComment",sender)
    }
    
    @IBAction func btnAddComment(_ sender: UIButton) {
        self.callback?("AddComment",sender)
    }
    
    @IBAction func btnreply(_ sender: UIButton) {
        self.callback?("reply", sender)
    }
    
    @IBAction func btnSeeMoreComment(_ sender: UIButton) {
        self.callback?("Seemorecomment",sender)
        
    }
    @IBAction func btnTapped(_ sender: UIButton) {
        self.callback?("btnimgTapped",sender)
    }
    
    @IBAction func btnChatTapped(_ sender: UIButton) {
        self.callback?("Chat",sender)
    }
    
    @IBAction func btnViewDetailsTapped(_ sender: UIButton){
        self.callback?("viewDetails",sender)
    }
    
    @IBAction func btnViewDetailsTwoTapped(_ sender: UIButton){
        self.callback?("viewDetails2",sender)
    }
    
    @IBAction func btnUserComment(_ sender: UIButton){
        self.callback?("Iconusercomment",sender)
        
    }
    
    @IBAction func btnUserSubComment(_ sender: UIButton){
        self.callback?("IconuserSubcomment",sender)
        
    }
    
    @IBAction func btnDescriptiontapped(_ sender: UIButton){
        self.callback?("Description",sender)
    }
    
}

extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img.count == 0 ? 1 : self.img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        if self.img.count == 0{
            cell.imgOpportunity.image = UIImage(named: "Banner")
            
        }else{
            
        let obj = img[indexPath.item].imageurl
        print("imgurl-=-\(obj)")
        let imageurl = "\(imgUrl)\(String.getString(obj))"
        print("imagebaseurl=-=-\(imageurl)")
        let userUrl = URL(string: imageurl)
//        cell.imgOpportunity.sd_setImage(with: userUrl, placeholderImage:UIImage(named: "Banner"))
        cell.imgOpportunity.seeFullImage()
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "Banner"))
        }
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.SocialPostCollectionView.frame.size.width, height: 225)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

// MARK: - Localisation

extension SocialPostTableViewCell{
    func setuplanguage(){
        self.txtviewComment.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Can we connect? I need service", comment: "")
//        lblcloseOpportunity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "This opportunity has been closed", comment: "")
        lbllike.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Like", comment: "")
        lblComment.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Comment", comment: "")
        lblShare.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Share", comment: "")
        lblSave.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Save", comment: "")
        btnReply.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Reply", comment: ""), for: .normal)
        btnSeemoreComment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "See more comments", comment: ""), for: .normal)
    }
}
