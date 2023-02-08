//  LikelistVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 08/02/23.

import UIKit

class LikelistVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
//    MARK: - Properties
    
    @IBOutlet weak var ListCountTV: UITableView!
    var oppr_id = 0
    
//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("opr_id=-=LikeList\(self.oppr_id)")
        ListCountTV.register(UINib(nibName: "LikeLIstTVC", bundle: Bundle.main), forCellReuseIdentifier: "LikeLIstTVC")
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
    }

// MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListCountTV.dequeueReusableCell(withIdentifier: "LikeLIstTVC") as! LikeLIstTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension LikelistVC{
   
//    MARK: - API Call
    
    
    // api like list
    
    func likelistyapi(){
        
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
            "opr_id":self.oppr_id
          
        ]
        
        debugPrint("user_id......",Int.getInt(UserData.shared.id))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.klikelist, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                    
                    else if  Int.getInt(dictResult["status"]) == 404{
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
//                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    
}
