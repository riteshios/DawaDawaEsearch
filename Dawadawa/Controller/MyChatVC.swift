//
//  MyChatVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 01/11/22.
//

import UIKit

class MyChatVC: UIViewController {

    @IBOutlet weak var tblviewMyChat: UITableView!
    var friendlist = [user_detail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendlistapi()
        tblviewMyChat.register(UINib(nibName: "MyChatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyChatTableViewCell")
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyChatVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendlist.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewMyChat.dequeueReusableCell(withIdentifier: "MyChatTableViewCell") as! MyChatTableViewCell
        
        let obj = friendlist[indexPath.row]
        let imgurl = String.getString(obj.social_profile)
        
        cell.lblName.text = String.getString(obj.name)
        cell.imgFriend.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
        cell.callback = { txt in
            if txt == "Chat"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                vc.friendid = Int.getInt(obj.id)
                vc.friendname = String.getString(obj.name)
                vc.friendimage = String.getString(obj.social_profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
       

        return cell
    }
    
}


extension MyChatVC {
//    API Call
    
    func friendlistapi(){
//        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
       
        
        let params:[String : Any] = [
            "user_id":UserData.shared.id,
            "friend_id": 0
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kaddfriend, requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
//            CommonUtils.showHudWithNoInteraction(show: false)
            
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
                        
                        let friendlist = kSharedInstance.getArray(withDictionary: dictResult["userData"])
                        self?.friendlist = friendlist.map{user_detail(data: kSharedInstance.getDictionary($0))}
                        print("DataAlldfriendlist===\(self?.friendlist)")
                        
                        self?.tblviewMyChat?.reloadData()
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    else if Int.getInt(dictResult["status"]) == 401{
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
