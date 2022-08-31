//
//  SocialPostTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

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
    @IBOutlet weak var Imageuser: UIImageView!
    
    @IBOutlet weak var imgOpp_plan: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var lbllike: UILabel!
    
    @IBOutlet weak var imgsave: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    @IBOutlet weak var heightSocialPostCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var imgOppFlag: UIImageView!
    
    
    
    //    Comment Section
    
    @IBOutlet weak var btnClickComment: UIButton!
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
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callback?("More", sender)
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Like", sender)
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
    
}


extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
    //    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        let obj = img[indexPath.item].imageurl
        print("-=-imgurl-=-\(obj)")
        let imageurl = "\(imgUrl)\(String.getString(obj))"
        print("-=imagebaseurl=-=-\(imageurl)")
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "baba"))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

