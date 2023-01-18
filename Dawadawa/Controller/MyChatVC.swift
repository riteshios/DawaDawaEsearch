//  MyChatVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/11/22.

import UIKit

class MyChatVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblMyChat: UILabel!
    @IBOutlet weak var tblviewMyChat: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var textFieldSearch:UITextField!
    
    var friendlist = [user_detail]()
    var searchData = [user_detail]()
    var txtdata = ""
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        viewSearch.addShadowWithBlurOnView(viewSearch, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.textFieldSearch.delegate = self
        tblviewMyChat.register(UINib(nibName: "MyChatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyChatTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friendlistapi()
    }
    
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func searchTextField(_ search: UITextField){
        searchData.removeAll()
        if search.text?.count == 0{
            self.searchData = self.friendlist
        }
        else{
            txtdata = search.text!
            for dicData in self.friendlist {
                
                let isMachingWorker : NSString = (dicData.name!) as NSString
                let range = isMachingWorker.lowercased.range(of: search.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                
                if range != nil {
                    searchData.append(dicData)
                }
            }
        }
        self.tblviewMyChat.reloadData()
    }
}

// MARK: - Tableview Delegate

extension MyChatVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchData.count == 0{
            CommonUtils.showError(.info, "User Not Found")
        }
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewMyChat.dequeueReusableCell(withIdentifier: "MyChatTableViewCell") as! MyChatTableViewCell
        
        let obj = searchData[indexPath.row]
        let imgurl = String.getString(obj.social_profile)
        
        cell.lblName.text = String.getString(obj.name)
        cell.imgFriend.downlodeImage(serviceurl: imgurl , placeHolder: UIImage(named: "Boss"))
        
        if Int.getInt(obj.unread) == 0{
            cell.viewCountMessage.isHidden = true
        }
        else{
            cell.viewCountMessage.isHidden = false
            cell.lblcountmessage.text = String(Int.getInt(obj.unread))
        }
        
        cell.callback = { txt in
            if txt == "Chat"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ChatVC.getStoryboardID()) as! ChatVC
                vc.friendid = Int.getInt(obj.id)
                vc.friendname = String.getString(obj.name)
                vc.friendimage = String.getString(obj.social_profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if txt == "Delete"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: DeleteChatPopUPVC.getStoryboardID()) as! DeleteChatPopUPVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callback = { txt in
                    
                    if txt == "Dismiss"{
                        self.dismiss(animated: true)
                    }
                    if txt == "DeleteChat"{
                        self.deleteChatapi(friendid: Int.getInt(obj.id))
                        self.dismiss(animated: true)
                    }
                }
                self.present(vc, animated: false)            }
        }
        return cell
    }
}
//  MARK: -   API Call
extension MyChatVC {
    
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
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kaddfriend, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            // CommonUtils.showHudWithNoInteraction(show: false)
            
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
                        self?.searchData = self!.friendlist
                        
                        self?.tblviewMyChat?.reloadData()
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    else if Int.getInt(dictResult["status"]) == 401{
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    //    API Delete Chat
    func deleteChatapi(friendid:Int){
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
            "delete_id":friendid,
            "login_user_id":UserData.shared.id
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kdeleteUsermessage, requestMethod: .POST,
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
                        CommonUtils.showError(.info, String.getString(dictResult["messages"]))
                        self?.friendlistapi()
                        
                    }
                    else if Int.getInt(dictResult["status"]) == 400{
//                        CommonUtils.showError(.info, String.getString(dictResult["messages"]))
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
extension MyChatVC{
    func setuplanguage(){
        lblMyChat.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "My Chat", comment: "")
        textFieldSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search Names", comment: "")
    }
}
