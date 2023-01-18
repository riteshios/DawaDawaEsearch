//  MysubscriptionVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 09/09/22.

import UIKit

class MysubscriptionVC: UIViewController {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var tblviewTransaction: UITableView!
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var lblPlan: UILabel!
    
    @IBOutlet weak var lblNumberofcreate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLeftbalance: UILabel!
    
    @IBOutlet weak var lblChoosePlan: UILabel!
    @IBOutlet weak var viewPlanShow: UIView!
    @IBOutlet weak var imgNoTransaction: UIImageView!
    @IBOutlet weak var lblNoTransaction: UILabel!
    @IBOutlet weak var lblSubNoTransaction: UILabel!
    
    @IBOutlet weak var btnBuyPlans: UIButton!
    @IBOutlet weak var heightViewPlanshow: NSLayoutConstraint!
    var hascomefrom = ""
    var activeplan:active_plan?
    var transaction = [trans_history]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.imgPlan.isHidden = true
        self.lblDate.isHidden = true
        self.getactiveplan()
        self.tblviewTransaction.isHidden = true
        
        tblviewTransaction.register(UINib(nibName: "TransactionHistory", bundle: Bundle.main), forCellReuseIdentifier: "TransactionHistory")
        
    }
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        if self.hascomefrom == "paymentVC"{
            kSharedAppDelegate?.makeRootViewController()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnBuyPlans(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: BuyPlanVC.getStoryboardID()) as! BuyPlanVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MysubscriptionVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewTransaction.dequeueReusableCell(withIdentifier: "TransactionHistory") as! TransactionHistory
        let obj = transaction[indexPath.row]
        
        cell.lblTransactionid.text = "\(String.getString(obj.transaction_id))"
        cell.lblAmount.text = "$\(String.getString(obj.amount))"
        cell.lblDate.text = "Transaction Date:- \(String.getString(obj.transaction_date))"
        
        if String.getString(obj.package?.title) == "Basic Plan"{
            cell.lblPlan.text = "Basic Plan"
            cell.imgPlan.image = UIImage(named: "Folded Booklet")
        }
        else if String.getString(obj.package?.title) == "Silver Plan"{
            cell.lblPlan.text = "Silver Plan"
            cell.imgPlan.image = UIImage(named: "Star Filled")
        }
        else if String.getString(obj.package?.title) == "Gold Plan"{
            cell.lblPlan.text = "Gold Plan"
            cell.imgPlan.image = UIImage(named: "Crown")
        }
        
        return cell
    }
}

extension MysubscriptionVC{
    //    API
    //    Active plan api
    
    func getactiveplan(){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let url = ServiceName.kgetactiveplan + "\(UserData.shared.id)/\(UserData.shared.user_type ?? "")"
        debugPrint("urlurl==",url)
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: url, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { [self] (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["responsecodes"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        self.activeplan = active_plan(data: data)
                        print("Dataactiveplan=\(self.activeplan)")
                        
                        self.lblPlan.text = self.activeplan?.package_name
                        
                        self.imgPlan.isHidden = false
                        self.lblDate.isHidden = false
                        self.imgNoTransaction.isHidden = true
                        self.lblNoTransaction.isHidden = true
                        self.lblSubNoTransaction.isHidden = true
                        self.lblChoosePlan.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Choose Plan", comment: "")
                        
                        if UserData.shared.user_type == "0"{
                            self.lblDate.text = "(expire on \(String.getString(self.activeplan?.end_date)))"
                            self.lblNumberofcreate.isHidden = true
                            self.lblLeftbalance.isHidden = true
                            self.heightViewPlanshow.constant = 62
                        }
                        else if UserData.shared.user_type == "1"{
                            self.lblNumberofcreate.text = "No. of Create: \(String.getString(self.activeplan?.balacedata?.total_no_create))"
                            self.lblDate.text = "Balance Used: \(String.getString(self.activeplan?.balacedata?.total_no_used))"
                            self.lblLeftbalance.text = "Left Balance:   \(String.getString(self.activeplan?.balacedata?.left_bal))"
                            self.heightViewPlanshow.constant = 92
                            
                        }
                        else if UserData.shared.user_type == "2"{
                            self.lblNumberofcreate.text = "No. of Create: \(String.getString(self.activeplan?.balacedata?.total_no_create))"
                            self.lblDate.text = "Balance Used: \(String.getString(self.activeplan?.balacedata?.total_no_used))"
                            self.lblLeftbalance.text = "Left Balance:  \(String.getString(self.activeplan?.balacedata?.left_bal))"
                            self.heightViewPlanshow.constant = 92
                            
                        }
                        
                        self.viewPlanShow.backgroundColor = UIColor(red: 1, green: 0.975, blue: 0.9, alpha: 1)
                        if String.getString(self.activeplan?.package_name) == "Basic Plan"{
                            self.imgPlan.image = UIImage(named: "Folded Booklet")
                        }
                        else if String.getString(self.activeplan?.package_name) == "Silver Plan"{
                            self.imgPlan.image = UIImage(named: "Star Filled")
                        }
                        else if String.getString(self.activeplan?.package_name) == "Gold Plan"{
                            self.imgPlan.image = UIImage(named: "Crown")
                        }
                        self.gettransaction_historyapi()
                    }
                    else if  Int.getInt(dictResult["responsecodes"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.lblNumberofcreate.isHidden = true
                        self.lblDate.isHidden = true
                        self.lblLeftbalance.isHidden = true
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
    //    Get transaction_History api
    
    func gettransaction_historyapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let url =  ServiceName.kgettransactionhistory + "\(UserData.shared.id)"
        debugPrint("urlhistory==",url)
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: url, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { [self] (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["responsecodes"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let data = kSharedInstance.getArray(withDictionary: dictResult["data"])
                        self.transaction = data.map{trans_history(data: kSharedInstance.getDictionary($0))}
                        
                        print("TransactionHistory=-\(self.transaction)")
                        self.tblviewTransaction.isHidden = false
                        self.imgNoTransaction.isHidden = true
                        self.lblNoTransaction.isHidden = true
                        self.lblSubNoTransaction.isHidden = true
                        self.tblviewTransaction.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["responsecodes"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
}
extension MysubscriptionVC{
    func setuplanguage(){
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Subscription", comment: "")
        lblNoTransaction.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "No transaction history", comment: "")
        lblSubNoTransaction.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "There is no transactions to show. Your all transactions will be shown here", comment: "")
        btnBuyPlans.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Buy Plans", comment: ""), for: .normal)
    }
}
