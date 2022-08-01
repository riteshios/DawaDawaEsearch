//
//  HomeVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit
import STTabbar

class HomeVC: UIViewController{
    

    @IBOutlet weak var tblViewViewPost: UITableView!
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var userdetail = [user_detail]()
    var cameFrom = ""
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ImgUser: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchdata()
        
        if cameFrom != "FilterData"{
            self.getallopportunity()
        }
        
        tblViewViewPost.register(UINib(nibName: "ViewPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ViewPostTableViewCell")
        tblViewViewPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        
    }
    
    func fetchdata(){
        self.lblUserName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        if let url = URL(string: "\("https://demo4app.com/dawadawa/public/admin_assets/user_profile/" + String.getString(UserData.shared.social_profile))"){
            debugPrint("url...",  url)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.ImgUser.image = UIImage(data: data)
                }
            }
            
            task.resume()
    }
       
  }
    
    override func viewWillAppear(_ animated: Bool) {
          self.hidesBottomBarWhenPushed = false
          self.tabBarController?.tabBar.isHidden = false
          self.tabBarController?.hidesBottomBarWhenPushed = false
          self.tabBarController?.tabBar.layer.zPosition = 0
      }

    @IBAction func btnSearchTapped(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 1
        
      
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: SearchVC.getStoryboardID()) as! SearchVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return userTimeLine.count
            
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            cell.callbacknavigation = { txt in
                if txt == "ViewAll"{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                self.navigationController?.pushViewController(vc, animated: true)
                }
                if txt == "Filter"{
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: FilterVC.getStoryboardID()) as! FilterVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            return cell
            
        case 1:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]

            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            debugPrint("username.....", cell.lblUserName.text)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
           
            let imguserurl = String.getString(obj.userdetail?.social_profile)
            debugPrint("socialprofile......",imguserurl)
         
            cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
            
            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
            
            cell.imgOpp_plan.image = obj.opp_plan == "Featured" ? UIImage(named: "Star Filled") : obj.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "")

          
            cell.callback = { txt in
                if txt == "Like"{
                if cell.btnlike.isSelected == true{
                    let oppid = self.userTimeLine[indexPath.row].id
                    debugPrint("oppidkkkkkkk=-=-",oppid)
                    self.likeOpportunityapi(oppr_id: oppid ?? 0)
        
                    cell.imglike.image = UIImage(named: "dil")
                    cell.lbllike.text = "Liked"
                    
                }
            }
            
                if txt == "More" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callback = { txt in
//                    if txt == "Dismiss"{
//                        vc.dismiss(animated: false){
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }
                    if txt == "Flag"{
                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                        self.flagopportunityapi(oppr_id: oppid)
                    }
                    
                    if txt == "Report"{
                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    
                }
                self.present(vc, animated: false)
            }
        }
            return cell
        
            
            
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 420
        case 1:
            return UITableView.automaticDimension
        
        default:
            return 0
        }
        
    }
    
  

}
    
    


extension HomeVC{
    
// Api all opportunity
    
    func getallopportunity(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetallopportunity, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
            
                        self.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("Dataallpost=\(self.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.tblViewViewPost.reloadData()
                        
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

    
   
    
// Api flag Opportunity
    
    func flagopportunityapi(oppr_id:Int){
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
//            "user_id":Int.getInt(UserData.shared.id),
            "opr_id":oppr_id
        ]
        
        debugPrint("opr_id......",oppr_id)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kflagpost, requestMethod: .POST,
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
                        kSharedAppDelegate?.makeRootViewController()
                        
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
                "opr_id":oppr_id
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
