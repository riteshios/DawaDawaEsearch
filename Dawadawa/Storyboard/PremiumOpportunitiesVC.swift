//
//  PremiumOpportunitiesVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PremiumOpportunitiesVC: UIViewController {
   
    
    @IBOutlet weak var tblViewPremiumOpp: UITableView!
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var img = [oppr_image]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getallpremium()
        tblViewPremiumOpp.register(UINib(nibName: "PremiumTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumTableViewCell")
        tblViewPremiumOpp.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        kSharedAppDelegate?.makeRootViewController()
    }
    
    
    
}

extension PremiumOpportunitiesVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return self.userTimeLine.count
            
            
            
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = self.tblViewPremiumOpp.dequeueReusableCell(withIdentifier: "PremiumTableViewCell") as! PremiumTableViewCell
            return cell
            
        case 1:
            let cell = self.tblViewPremiumOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.lblTitle.text = String.getString(obj.title)
            let imgurl = String.getString(obj.userdetail?.social_profile)
            debugPrint("socialprofile......",imgurl)
            cell.Imageuser.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
            
            return cell
            
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 65
        case 1:
            return UITableView.automaticDimension
        
        default:
            return 0
        }
        
    }
    
}

extension PremiumOpportunitiesVC{
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
                        self.tblViewPremiumOpp.reloadData()
                        
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



