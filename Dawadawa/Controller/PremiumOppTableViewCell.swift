//  PremiumOppTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 21/07/22.

import UIKit

class PremiumOppTableViewCell: UITableViewCell {

    @IBOutlet weak var ColllectionViewPremiumOpp: UICollectionView!
    @IBOutlet weak var lblPremium_opp: UILabel!
    @IBOutlet weak var btnViewall: UIButton!
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var img = [oppr_image]()
    
    var callbacknavigation:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.getallpremium()
        self.setuplanguage()
        ColllectionViewPremiumOpp.delegate = self
        ColllectionViewPremiumOpp.dataSource = self
        ColllectionViewPremiumOpp.register(UINib(nibName: "PremiumOppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PremiumOppCollectionViewCell")
    }

    @IBAction func btnViewAllTapped(_ sender: UIButton) {
        self.callbacknavigation?()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
extension PremiumOppTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userTimeLine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ColllectionViewPremiumOpp.dequeueReusableCell(withReuseIdentifier: "PremiumOppCollectionViewCell", for: indexPath) as! PremiumOppCollectionViewCell
        let obj = userTimeLine[indexPath.row]
     
        debugPrint("obj......",obj)
        cell.lbltitle.text = String.getString(obj.title)
        cell.imgPremium.downlodeImage(serviceurl: "\(imgUrl)\(String.getString(obj.oppimage.first?.imageurl))", placeHolder: UIImage(named: "truck"))
        return cell
    }
   

  
}


extension PremiumOppTableViewCell{
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
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.ColllectionViewPremiumOpp.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                  
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
}

// MARK: - Localisation

extension PremiumOppTableViewCell{
    func setuplanguage(){
        self.lblPremium_opp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Premium Opportunities", comment: "")
        self.btnViewall.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "View all", comment: ""), for: .normal)
    }
}

