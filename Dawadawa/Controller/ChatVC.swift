//
//  ChatVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 31/10/22.
//

import UIKit
import IQKeyboardManagerSwift

class ChatVC: UIViewController{
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var txtViewMessage: IQTextView!
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var lblNameFriend: UILabel!
    
    
    var friendid = 0
    var Messagedata = [Message_data]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.addfriendapi()
        self.getmessageeapi()
        
        viewTop.clipsToBounds = true
        viewTop.layer.cornerRadius = 10
        viewTop.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        tableViewChat?.register(UINib(nibName: "ChatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ChatTableViewCell")
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendTapped(_ sender: UIButton) {
        
        self.sendmessageapi()
    }
    
    
}

extension ChatVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messagedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewChat.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        let obj = Messagedata[indexPath.row]
        
        cell.setUser(user: obj.from, message: obj.message)
            
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension ChatVC {
    
    //    Api call
    
    //    API Add friend
    func addfriendapi(){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        debugPrint("friend_id=-=-",self.friendid)
        
        let params:[String : Any] = [
            "user_id":UserData.shared.id,
            "friend_id":friendid
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kaddfriend, requestMethod: .POST,
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
    
    //    API send message
    
    func sendmessageapi(){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        debugPrint("friend_id=-=-",self.friendid)
        
        let params:[String : Any] = [
            "sender_id":UserData.shared.id,
            "receiver_id":friendid,
            "message":String.getString(self.txtViewMessage.text)
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.ksendmessage, requestMethod: .POST,
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
                        self?.getmessageeapi()
                        self?.txtViewMessage.text = ""
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
    
    //    API Get Messsage
    
    func getmessageeapi(){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        debugPrint("friend_id=-=-",self.friendid)
        
        let params:[String : Any] = [
            "my_id":UserData.shared.id,
            "user_id":friendid
        ]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kgetmessage, requestMethod: .POST,
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
                        
                        let message = kSharedInstance.getArray(withDictionary: dictResult["messages"])
                        self?.Messagedata = message.map{Message_data(data: kSharedInstance.getDictionary($0))}
                        print("DataAllMessageData===\(self?.Messagedata)")
                        
                        self?.tableViewChat?.reloadData()
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
