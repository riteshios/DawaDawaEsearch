//  ViewPostTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 20/07/22.

import UIKit

var opppreid = 0
var likeCount = ""

class ViewPostTableViewCell: UITableViewCell{
    @IBOutlet weak var lblPremium_opp: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var ColllectionViewPremiumOpp: UICollectionView!
    var callbacknavigation:((String)->())?
    
    @IBOutlet weak var heightMainView: NSLayoutConstraint!
    @IBOutlet weak var heightViewCollectionview: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var img = [oppr_image]()
    
    weak var celldelegate: PremiumOppCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        ColllectionViewPremiumOpp.delegate = self
        ColllectionViewPremiumOpp.dataSource = self
        ColllectionViewPremiumOpp.register(UINib(nibName: "PremiumOppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PremiumOppCollectionViewCell")
        self.getallpremium()
    }
    
    @IBAction func btnViewAll(_ sender: UIButton) {
        self.callbacknavigation?("ViewAll")
        
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        self.callbacknavigation?("Filter")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//    MARK: - Table View Delegate -

extension ViewPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userTimeLine.count
        
        debugPrint("premiumcount======",self.userTimeLine.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ColllectionViewPremiumOpp.dequeueReusableCell(withReuseIdentifier: "PremiumOppCollectionViewCell", for: indexPath) as! PremiumOppCollectionViewCell
        let obj = userTimeLine[indexPath.row]
        
        debugPrint("obj......",obj)
        cell.lbltitle.text = String.getString(obj.title)
        cell.imgPremium.downlodeImage(serviceurl: "\(imgUrl)\(String.getString(obj.oppimage.first?.imageurl))", placeHolder: UIImage(named: "Frame 726"))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
           let oppid = userTimeLine[indexPath.row].id
           opppreid = oppid ?? 0
        
            let cell = ColllectionViewPremiumOpp.cellForItem(at: indexPath) as! PremiumOppCollectionViewCell
            self.celldelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
            return
        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 205)
    }
    
}

// MARK: - Api call

extension ViewPostTableViewCell{
    //    Api opportunity premium
    func getallpremium(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetpremium, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        self.imgUrl = String.getString(dictResult["opr_base_url"])
                        debugPrint("PreimiumImgurl=====", self.imgUrl)
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataAllPremiumPost===\(self.userTimeLine)")
                        
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.ColllectionViewPremiumOpp.reloadData()
                        
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
//                CommonUtils.showToastForDefaultError()
            }
        }
        
    }
}

// MARK: - Localisation

extension ViewPostTableViewCell{
    func setuplanguage(){
        lblPremium_opp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Premium opportunities", comment: "")
        btnViewAll.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "View all", comment: ""), for: .normal)
    }
}
