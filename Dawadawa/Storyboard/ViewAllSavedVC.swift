//
//  ViewAllSavedVC.swift
//  Dawadawa
//
//  Created by Alekh on 09/08/22.
//

import UIKit

class ViewAllSavedVC: UIViewController {

    @IBOutlet weak var TblViewSavedOpp: UITableView!
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    private func setup(){
        TblViewSavedOpp.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: SavedOpportunitiesVC.getStoryboardID()) as! SavedOpportunitiesVC
        self.navigationController?.pushViewController(vc, animated: false)
//        self.navigationController?.popViewController(animated: true)

        
    }
    
    
}

extension ViewAllSavedVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTimeLine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TblViewSavedOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
        let obj = userTimeLine[indexPath.row]
        
        cell.SocialPostCollectionView.tag = indexPath.section
        cell.lblUserName.text = String.getString(obj.userdetail?.name)
        debugPrint("username.....", cell.lblUserName.text)
        cell.lblDescribtion.text = String.getString(obj.description)
        cell.img = obj.oppimage
        cell.imgUrl = self.imgUrl
        
        let imguserurl = String.getString(obj.userdetail?.social_profile)
        debugPrint("socialprofile......",imguserurl)
        
        cell.Imageuser.downlodeImage(serviceurl: imguserurl , placeHolder: UIImage(named: "Boss"))
        
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
                if cell.btnlike.isSelected == true{
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
            }
            
            if txt == "Save"{
                let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                debugPrint("saveoppid=-=-=",oppid)
                self.saveoppoertunityapi(oppr_id: oppid)
                cell.imgsave.image = UIImage(named: "saveopr")
                cell.lblSave.text = "Saved"
            }
            
            
            
            
            if txt == "More" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: SaveOpportunityMoreVC.getStoryboardID()) as! SaveOpportunityMoreVC
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
                    
                    if txt == "Unsaved"{
                        let oppid = Int.getInt(self.userTimeLine[indexPath.row].id)
                        self.unsaveoppoertunityapi(oppr_id: oppid)
                        cell.imgsave.image = UIImage(named: "save-3")
                        cell.lblSave.text = "Save"
                        self.dismiss(animated: true)
                    }
                    
                }
                self.present(vc, animated: false)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ViewAllSavedVC{
    
//    API CALL
    
    
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
    
    //    Unsaved Opportunity
    
    func unsaveoppoertunityapi(oppr_id:Int){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kunsavedopp, requestMethod: .POST,
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
//                        self?.TblViewSavedOpp.reloadData()
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
        
}
