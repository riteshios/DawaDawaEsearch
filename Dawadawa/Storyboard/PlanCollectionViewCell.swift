//  PlanCollectionViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/08/22.

import UIKit

class PlanCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var PlantableView: UITableView!
    @IBOutlet weak var ViewBG: UIView!
    
    var planimage = [UIImage(named: "Ok"),UIImage(named: "Star Filled"),UIImage(named: "Crown")]
    
    var subsdata:Subscription_data?{
        didSet{
            self.PlantableView.reloadData()
        }
    }
    
    var descData = [description_plan](){
        didSet{
            self.PlantableView.reloadData()
        }
    }
    
    var cellnumber = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PlantableView.delegate = self
        PlantableView.dataSource = self
        
        PlantableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: "PlanTableViewCell")
        PlantableView.register(UINib(nibName: "PlanListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlanListTableViewCell")
        //        self.getsubsplanapi()
        self.ViewBG.addShadowWithCornerRadius(ViewBG, cRadius: 5)
        
    }

    
    func cellnumbercount(num : Int)
    {
        debugPrint("ScrollCount=",num)
        cellnumber = num
    }
    
}
extension PlanCollectionViewCell: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:

            return 1
            
        case 1:
            
           return self.descData.count
//            if subsdata.count != 0{
//
//                return subsdata[cellnumber].description.count
//            }else{
//                return 0
//            }
            
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.PlantableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell") as! PlanTableViewCell
            
            //   cell.lblPlan.text = self.plan[cellnumber]
            let obj = self.subsdata
            cell.lblPlan.text = String.getString(obj?.planNmae)
            
            if UserData.shared.user_type == "0"{
                cell.lblPricePerMonth.text = "$" + String.getString(obj?.price_month)
//                cell.lblCutPricePerYear.text = "Price: - $" + String.getString(obj?.cut_year_price)
//                cell.lblPricePerYear.text = "$" + String.getString(obj?.price_year)
               
            }
            
            else if UserData.shared.user_type == "1"{
//                cell.lblMonth.isHidden = true
//                cell.lblYear.isHidden = true
//                cell.lblPricePerYear.isHidden = true
//                cell.viewLine.isHidden = true
                cell.lblPricePerMonth.text = "$\(String.getString(obj?.price_month))"
                cell.lblCutPricePerYear.text = "- \(String.getString(obj?.no_create))"
            }
            
            else if UserData.shared.user_type == "2"{
//                cell.lblMonth.isHidden = true
//                cell.lblYear.isHidden = true
//                cell.lblPricePerYear.isHidden = true
//                cell.viewLine.isHidden = true
                cell.lblPricePerMonth.text = "$\(String.getString(obj?.price_month))"
                cell.lblCutPricePerYear.text = "\(String.getString(obj?.no_create))"
            }
            
            return cell
            
        case 1:
            
            let cell = self.PlantableView.dequeueReusableCell(withIdentifier: "PlanListTableViewCell") as! PlanListTableViewCell
            
         //   let obj = self.subsdata[cellnumber].description[indexPath.row]
            let obj = self.descData[indexPath.row]
            let imgUrl = URL(string: String.getString(subsdata?.image))
           // cell.imgPlan.image = planimage[cellnumber]
          //  cell.imgPlan.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "Ok"))
            cell.lblPlan.text = String.getString(obj.key)
            
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 200
        case 1:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
    }
}

/*
 extension PlanCollectionViewCell{
 
 
 //    Get SubscriptionPlan Api
 
 func getsubsplanapi(){
 CommonUtils.showHudWithNoInteraction(show: true)
 
 if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
 let endToken = kSharedUserDefaults.getLoggedInAccessToken()
 let septoken = endToken.components(separatedBy: " ")
 if septoken[0] != "Bearer"{
 let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
 kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
 }
 }
 
 
 TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetsubscriptionplan, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
 
 
 let sub = kSharedInstance.getArray(withDictionary: dictResult["data"])
 self.subsdata = sub.map{Subscription_data(data: kSharedInstance.getDictionary($0))}
 print("DataSubsData=\(self.subsdata)")
 
 
 DispatchQueue.main.async {
 self.PlantableView.reloadData()
 }
 
 }
 else if  Int.getInt(dictResult["responsecode"]) == 400{
 //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
 */
// Global Api
extension UIViewController{
    func getSubcriptionPlan(completionHandler: @escaping(([Subscription_data])->Void)){
        CommonUtils.showHudWithNoInteraction(show: true)
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let url =  ServiceName.kgetsubscriptionplan + "\(String.getString(UserData.shared.user_type))"
        debugPrint("urlhistory==",url)
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: url, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        let sub = kSharedInstance.getArray(withDictionary: dictResult["data"])
                        let subData = sub.map{Subscription_data(data: kSharedInstance.getDictionary($0))}
                        print("DataSubsData=\(subData)")
                        completionHandler(subData)
                        
                    }
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
