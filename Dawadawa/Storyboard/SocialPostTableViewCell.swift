//
//  SocialPostTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class SocialPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    var callback:((String)->())?
    
 
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var Imageuser: UIImageView!
    
    @IBOutlet weak var imgOpp_plan: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var lbllike: UILabel!
    
   
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
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
      
      
    }
    
    func setup(){
    
        
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callback?("More")
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Like")
    }
    
}
 

extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        let obj = img[indexPath.item].image
        print("-=-imgurl-=-\(obj)")
        let imageurl = "\(imgUrl)\(String.getString(obj))"
        print("-=imagebaseurl=-=-\(imageurl)")
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "truck"))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension SocialPostTableViewCell{
    
//    Api like Opportunity
    
    func likeOpportunityapi(oppr_id:Int){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.klikeopportunity, requestMethod: .POST,
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
