//  DetailsTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 21/09/22.

import UIKit
import IQKeyboardManagerSwift


var doc_url = ""
class DetailsTableViewCell: UITableViewCell,UITextViewDelegate {
    
    //    MARK: - Properties -
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    @IBOutlet weak var DocumentCollectionView: UICollectionView!
    
    var callback:((String, UIButton)->())?
    var callbacktextviewcomment: ((String) -> Void)?
    
    @IBOutlet weak var heightAddComment: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var lblShare: UILabel!
    
    @IBOutlet weak var imgsave: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    @IBOutlet weak var lblCommentCout: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var WidthViewRating: NSLayoutConstraint!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSub_category: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblBusinessminingType: UILabel!
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblLocationONMap: UILabel!
    @IBOutlet weak var llbMobileNumber: UILabel!
    @IBOutlet weak var lbblWhatsappNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var ViewBusinessName: UIView!
    @IBOutlet weak var viewBusinessminingType: UIView!
    
    
    @IBOutlet weak var heightSocialPostCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var heightDocumentcollectionview: NSLayoutConstraint!
    
    @IBOutlet weak var heightViewBusinessName: NSLayoutConstraint!
    @IBOutlet weak var heightviewBusinessminingtype: NSLayoutConstraint!
    @IBOutlet weak var imgOppFlag: UIImageView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var viewSeeDetails: UIView!
    @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewSubCategory: UIView!
    
    
    weak var celldelegate: DocumentCollectionViewCellDelegate?
    
    //    Comment Section
    
    @IBOutlet weak var btnClickComment: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var txtviewComment: IQTextView!
    
    @IBOutlet weak var viewAddComment: UIView!
    
    @IBOutlet weak var heightViewAddComment: NSLayoutConstraint!
    
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
    var doc = [oppr_document](){
        didSet{
            self.DocumentCollectionView.reloadData()
        }
    }
    
    //    MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        SocialPostCollectionView.delegate = self
        SocialPostCollectionView.dataSource = self
        DocumentCollectionView.delegate = self
        DocumentCollectionView.dataSource = self
        SocialPostCollectionView.register(UINib(nibName: "SocialPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialPostCollectionViewCell")
        DocumentCollectionView.register(UINib(nibName: "DocumentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DocumentCollectionViewCell")
        pageControl.numberOfPages = img.count
        pageControl.currentPage = 0
        
        
        self.txtviewComment.delegate = self
        self.viewAddComment.isHidden = true
        //   self.heightViewAddComment.constant = 0
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
    
    @IBAction func btnChattapped(_ sender: UIButton){
        self.callback?("Chat",sender)
    }
    
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callback?("More", sender)
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Like", sender)
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
    
}


extension DetailsTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //    Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case self.SocialPostCollectionView:
            return self.img.count == 0 ? 1 : self.img.count

        case self.DocumentCollectionView:
            return self.doc.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
            
            case self.SocialPostCollectionView:
            
            let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
            
            if self.img.count == 0{
                cell.imgOpportunity.image = UIImage(named: "Banner")
            }
            else{
                let obj = img[indexPath.item].imageurl
                print("-=-imgurl-=-\(String(describing: obj))")
                let imageurl = "\(imgUrl)\(String.getString(obj))"
                let imgUrl = URL(string: "\(imgUrl)\(String.getString(obj))")
                print("-=imagebaseurl=-=-\(imageurl)")
                cell.imgOpportunity.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "Frame 726"))
                // cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "baba"))
              
                cell.imgOpportunity.seeFullImage()
            }
            return cell
            
            
        case self.DocumentCollectionView:
            
            let cell = DocumentCollectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCollectionViewCell", for: indexPath) as! DocumentCollectionViewCell
            let obj = doc[indexPath.item].oppr_document
            cell.lblDocument.text = String.getString(obj)
            
            cell.callback?(indexPath.row) // get the index from table view cell using call back
            
            return cell
            
        default:
            return UICollectionViewCell()
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView{

        case self.SocialPostCollectionView:
            return CGSize(width: SocialPostCollectionView.frame.size.width, height: SocialPostCollectionView.frame.size.height)
            
        case self.DocumentCollectionView:
            return CGSize(width: SocialPostCollectionView.frame.size.width, height: 60)
            
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{

        case self.DocumentCollectionView:
            let opr_doc = doc[indexPath.item].oppr_document ?? ""
            doc_url = opr_doc
            print("docurl=-0=\(doc_url)")
            let cell = DocumentCollectionView.cellForItem(at: indexPath) as! DocumentCollectionViewCell
            self.celldelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
            return
            
        default:
            return
        }
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

// MARK: - Localisation

extension DetailsTableViewCell{
    func setuplanguage(){
        lbllike.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Like", comment: "")
        lblComment.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Comment", comment: "")
        lblShare.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Share", comment: "")
        lblSave.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Save", comment: "")
    }
}



