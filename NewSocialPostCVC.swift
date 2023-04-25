//  NewSocialPostCVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 27/03/23.

import UIKit

protocol NewSocialPostCVCDelegate: class {
    func SeeDetails(collectionviewcell: NewSocialPostCVC?, index: Int, didTappedInTableViewCell: SocialPostTVC)
    func More(collectionviewcell:NewSocialPostCVC?, index: Int, didTappedintableviewcell: SocialPostTVC)
    func likecount(collectionviewcell:NewSocialPostCVC?, index: Int, didTappedintableviewcell: SocialPostTVC)
    // other delegate methods that you can define to perform action in viewcontroller
}

class NewSocialPostCVC: UICollectionViewCell{
    
//    MARK: - Properties : -
    
    var callback:((String,UIButton)->())?
    
    @IBOutlet weak var ViewAvailable: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCommentCout: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblcloseOpportunity: UILabel!
    @IBOutlet weak var imgOpportunity: UIImageView!
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var btnSeeDetail: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewAvailable.layer.cornerRadius = 20
        ViewAvailable.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.setuplanguage()
    }
    
//    override func layoutSubviews() {
//        if kSharedUserDefaults.getlanguage() as? String == "en"{
//            DispatchQueue.main.async {
//                self.ViewAvailable.semanticContentAttribute = .forceLeftToRight
//                self.lblCat.semanticContentAttribute = .forceLeftToRight
//                self.lblUser.textAlignment = .left
//                self.lblUserName.textAlignment = .left
//                self.lblCat.textAlignment = .left
//                self.lblCategoryName.textAlignment = .left
//                print("English Changed")
//            }
//        }
//        else {
//            DispatchQueue.main.async {
//                self.ViewAvailable.semanticContentAttribute = .forceRightToLeft
//                self.lblUser.textAlignment = .right
//                self.lblUserName.textAlignment = .right
//                self.lblCat.semanticContentAttribute = .
//                self.lblCat.textAlignment = .right
//                self.lblCategoryName.textAlignment = .right
//                print("Arabic Changed")
//            }
//        }
//    }
    
//    MARK: - @IBActions -

    @IBAction func btnSeeDetailsTapped(_ sender: UIButton) {
        self.callback?("viewDetails",sender)
    }
    
    @IBAction func BtnMoreTapped(_ sender: UIButton) {
        self.callback?("More", sender)
    }
    
    @IBAction func BtnLikeTapped(_ sender: UIButton){
        self.callback?("Like", sender)
    }
    
    @IBAction func BtnLikeCountTapped(_ sender: UIButton){
        self.callback?("LikeCount", sender)
    }
    
}

//  MARK: - Localisation -

extension NewSocialPostCVC{
    
    func setuplanguage(){
        lblCat.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cat:", comment: "")
        lblUser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "UserName:-", comment: "")
        lblMore.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "More", comment: "")
        btnSeeDetail.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "See Details", comment: ""), for: .normal)
    }
}
