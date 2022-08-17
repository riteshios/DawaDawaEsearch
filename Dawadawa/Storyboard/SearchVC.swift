//
//  SearchVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class SearchVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var tblViewSearchOpp: UITableView!
    @IBOutlet weak var txtfieldSearch: UITextField!
    @IBOutlet weak var imgNotfound: UIImageView!
    
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var img = [oppr_image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.imgNotfound.isHidden = true
        self.setup()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.hidesBottomBarWhenPushed = false
//        self.tabBarController?.tabBar.isHidden = false
//        self.tabBarController?.hidesBottomBarWhenPushed = false
//        self.tabBarController?.tabBar.layer.zPosition = 0
//    }
   

    
    func setup(){
        tblViewSearchOpp.register(UINib(nibName: "PopularSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PopularSearchTableViewCell")
        
        tblViewSearchOpp.register(UINib(nibName: "PremiumOppTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumOppTableViewCell")
        
        tblViewSearchOpp.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        txtfieldSearch.delegate = self
        txtfieldSearch.returnKeyType = .done
    }
}
extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return 1
            
        case 2:
            return userTimeLine.count
            
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
            
            
        case 0:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PopularSearchTableViewCell") as! PopularSearchTableViewCell
            cell.SearchCollectionView.tag = indexPath.section
            return cell
            
            
            
        case 1:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PremiumOppTableViewCell") as! PremiumOppTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            cell.callbacknavigation = {
                if UserData.shared.isskiplogin == true{
                    self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                }
                else{
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
            
            
            
        case 2:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            let obj = userTimeLine[indexPath.row]
            
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.lblUserName.text = String.getString(obj.userdetail?.name)
            debugPrint("username.....", cell.lblUserName.text)
            cell.lblTitle.text = String.getString(obj.title)
            cell.lblDescribtion.text = String.getString(obj.description)
            cell.img = obj.oppimage
            cell.imgUrl = self.imgUrl
            
            let imgurl = String.getString(obj.userdetail?.social_profile)
            debugPrint("socialprofile......",imgurl)
            
            cell.Imageuser.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
            
            cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
            
            cell.imgOpp_plan.image = obj.opp_plan == "Featured" ? UIImage(named: "Star Filled") : obj.opp_plan == "Premium" ? UIImage(named: "Crown") : UIImage(named: "")
            
            
            
            if Int.getInt(obj.close_opr) == 0{
                           cell.lblTitle.text = String.getString(obj.title)
                           cell.lblTitle.textColor = .black
                       }
            else{
                cell.lblTitle.text = "This Opprortunity has been Closed"
                cell.lblTitle.textColor = .red
            }
            if String.getString(obj.is_user_like) == "1"{
                cell.imglike.image = UIImage(named: "dil")
                cell.lbllike.text = "Liked"
              
            }
            else{
                cell.imglike.image = UIImage(named: "unlike")
                cell.lbllike.text = "Like"
            }
            if String.getString(obj.is_saved) == "1"{
                cell.imgsave.image = UIImage(named: "saveopr")
                cell.lblSave.text = "Saved"
            }
            else{
                cell.imgsave.image = UIImage(named: "save-3")
                cell.lblSave.text = "Save"
            }
            
            
            
            cell.callback = { txt in
                
                if txt == "Like"{
                    if UserData.shared.isskiplogin == true{
                        self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                    }
                    else{
                    let oppid = self.userTimeLine[indexPath.row].id
                            debugPrint("oppid--=-=-=-",oppid)
//                            self.likeOpportunityapi(oppr_id: oppid ?? 0)
                            self.likeOpportunityapi(oppr_id: oppid ?? 0) { countLike in
                                obj.likes = Int.getInt(countLike)
                                cell.lblLikeCount.text = String.getString(obj.likes) + " " + "likes"
                            }
                            cell.imglike.image = UIImage(named: "dil")
                            cell.lbllike.text = "Liked"
                    
                    }
                }
                
                
                if txt == "Save"{
                    let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                    debugPrint("saveoppid=-=-=",oppid)
                    self.saveoppoertunityapi(oppr_id: oppid)
                    cell.imgsave.image = UIImage(named: "saveopr")
                    cell.lblSave.text = "Saved"
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
                            if UserData.shared.isskiplogin == true{
                                self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                            }
                            else{
                                let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                                self.flagopportunityapi(oppr_id: oppid)
                            }
                        }
                        
                        if txt == "Report"{
                            if UserData.shared.isskiplogin == true{
                                self.showSimpleAlert(message: "Not Available for Guest User Please Register for Full Access")
                            }
                            else{
                                kSharedAppDelegate?.makeRootViewController()
                            }
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
            return 195
            
        case 1:
            return UITableView.automaticDimension

        case 2:
            
            return UITableView.automaticDimension
            
            
        default:
            return 0
        }
        
    }
//    TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        txtfieldSearch.resignFirstResponder()
        if UserData.shared.isskiplogin == true{
            self.guestsearchopportunityapi()
        }
        else{
            self.searchopportunityapi()
        }
        
        return true
    }
}


extension SearchVC{
    
    // Search Api

    func searchopportunityapi(){
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
            "search":String.getString(self.txtfieldSearch.text),
            "user_id":Int.getInt(UserData.shared.id)
        ]
        
        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksearchopportunity, requestMethod: .POST,
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
                        
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                       
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
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
    
    func likeOpportunityapi(oppr_id:Int,completion: @escaping(_ countLike: String)->Void){
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
//                    self?.statuslike = Int.getInt(dictResult["status"])
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
//                        self?.count = String.getString(dictResult["count"])
//                        debugPrint("likecount=-=-=-=",self?.count)
                        completion(String.getString(dictResult["count"]))
                       
                        
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
    
    //    Save Opportunity Api
        
        func saveoppoertunityapi(oppr_id:Int){
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
            TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.ksaveOpp, requestMethod: .POST,
                                                       requestParameters:params, withProgressHUD: false)
            {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
                
                CommonUtils.showHudWithNoInteraction(show: false)
                
                if errorType == .requestSuccess {
                    
                    let dictResult = kSharedInstance.getDictionary(result)
                    
                    switch Int.getInt(statusCode) {
                    case 200:
                        
                        if Int.getInt(dictResult["responsecode"]) == 200{
                            
                            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                            let septoken = endToken.components(separatedBy: " ")
                            if septoken[0] == "Bearer"{
                                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                            }
                          
                            CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        }
                        
                        else if  Int.getInt(dictResult["responsecode"]) == 400{
                            //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
//    Guest Search api
    
    func guestsearchopportunityapi(){
        CommonUtils.showHud(show: true)
        
        
        let params:[String : Any] = [
            "search":String.getString(self.txtfieldSearch.text)
        
        ]
        
        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestsearchopportunity, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self?.imgNotfound.isHidden = true
                        self?.tblViewSearchOpp.reloadData()
                        
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.imgNotfound.isHidden = false
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
