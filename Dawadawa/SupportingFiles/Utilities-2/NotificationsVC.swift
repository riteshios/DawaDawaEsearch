//  NotificationsVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 10/10/22.

import UIKit

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var btnMarkAllRead: UIButton!
    @IBOutlet weak var tblviewNotification: UITableView!
    var NotificationData = [Notification_data]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        tblviewNotification.register(UINib(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getallNotification()
        }
    
//    MARK: - @IBAction and Method - 
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMarkAllreadTapped(_ sender: UIButton) {
        self.markallreadapi()
       
    }
}

// MARK: - Table view Delegate

extension NotificationsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewNotification.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        let obj = self.NotificationData[indexPath.row]
        
        cell.lblHeading.text = String.getString(obj.title)
        cell.lblSubheading.text = String.getString(obj.body)
        
        if String.getString(obj.read_status) == "1"{
            cell.viewNotification.backgroundColor = UIColor.white
            cell.lblHeading.textColor = UIColor.black
            cell.lblSubheading.textColor = UIColor.black
            cell.imglogo.image = UIImage(named: "logo-1")
        }
        else if String.getString(obj.read_status) == "0"{
            cell.viewNotification.backgroundColor = UIColor.init(hexString: "#1572A1")
            cell.lblHeading.textColor = UIColor.white
            cell.lblSubheading.textColor = UIColor.white
            cell.imglogo.image = UIImage(named: "logo")
        }
        
        
        cell.callback = { txt, sender in
            
            if txt == "Notificationdetail"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationDetail") as! NotificationDetail
                vc.noti_id = Int.getInt(obj.id)
                vc.heading = String.getString(obj.title)
                vc.subheading = String.getString(obj.body)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
}

// MARK: - API Call

extension NotificationsVC{
    
    //    Api getallNotification
    
    func getallNotification(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetallNotification, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        let Data = kSharedInstance.getArray(withDictionary: dictResult["data"])
                        self.NotificationData = Data.map{Notification_data(data: kSharedInstance.getDictionary($0))}
                        print("DataallNotification=\(self.NotificationData)")
                        
                        self.tblviewNotification.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
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
    
    //    Api Mark all read
    
    func markallreadapi(){
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
            "user_id":UserData.shared.id]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.kmarkallread, requestMethod: .POST,
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
                        self?.getallNotification()
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
//                CommonUtils.showToastForDefaultError()
            }
        }
    }
}

extension NotificationsVC{
    func setuplanguage(){
        lblNotification.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Notifications", comment: "")
        btnMarkAllRead.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mark all as read", comment: ""), for: .normal)
    }
}
