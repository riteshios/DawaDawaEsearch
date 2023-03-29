//  NewSocialPostCVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 27/03/23.

import UIKit

protocol NewSocialPostCVCDelegate: class {
    func SeeDetails(collectionviewcell: NewSocialPostCVC?, index: Int, didTappedInTableViewCell: SocialPostTVC)
//    func likeOpp(collectionviewcell:NewSocialPostCVC?, index: Int, didTappedintableviewcell: SocialPostTVC)
    // other delegate methods that you can define to perform action in viewcontroller
}

class NewSocialPostCVC: UICollectionViewCell{
    
//    MARK: - Properties : -
    
    var callback:((String,UIButton)->())?
    
    @IBOutlet weak var ViewAvailable: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCommentCout: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblcloseOpportunity: UILabel!
    @IBOutlet weak var imgOpportunity: UIImageView!
    @IBOutlet weak var imglike: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewAvailable.layer.cornerRadius = 20
        ViewAvailable.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
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
    
}
