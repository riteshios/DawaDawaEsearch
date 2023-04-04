//  SocialPostTVC.swift
//  Dawadawa
//  Created by Ritesh  on 26/03/23.

import UIKit

var sharelink = ""
var user_id = 0
var imguser_url = ""
var frnd_name = ""
var statuscode = 0

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
//        self.getallopportunity()
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
        
        if statuscode == 200 {
            cell.lblcloseOpportunity.text = "Closed"
            cell.lblcloseOpportunity.textColor = UIColor(hexString: "#FF4C4D")
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
            if txt == "LikeCount" {
                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                opppreid = oppid ?? 0
                let likecount = String.getString(userTimeLine[indexPath.row].likes)
                likeCount = likecount ?? ""
                self.celldelegate?.likecount(collectionviewcell: cell, index: indexPath.item, didTappedintableviewcell: self)
            }
            
            if txt == "More" {
                let oppid = Int.getInt(userTimeLine[indexPath.row].id)
                opppreid = oppid ?? 0
                let share_link = String.getString(userTimeLine[indexPath.row].share_link)
                sharelink = share_link ?? ""
                let userid = Int.getInt(userTimeLine[indexPath.row].user_id)
                user_id = userid ?? 0
                let imguserurl = String.getString(userTimeLine[indexPath.row].userdetail?.social_profile)
                imguser_url = imguserurl ?? ""
                let frndnname = String.getString(userTimeLine[indexPath.row].userdetail?.name)
                frnd_name = frndnname ?? ""
                self.celldelegate?.More(collectionviewcell: cell, index: indexPath.item, didTappedintableviewcell: self)
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
