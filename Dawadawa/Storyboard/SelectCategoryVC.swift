//  SelectCategoryVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 07/07/22.

import UIKit
import Alamofire
import SwiftyJSON
import CoreMedia
import SKFloatingTextField
import SDWebImage

class SelectCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    MARK: - Properties
    
    @IBOutlet weak var viewUpper: UIView!
    @IBOutlet weak var lblSelectCategory: UILabel!
    @IBOutlet weak var tableviewSelectCategory: UITableView!
    
    var getCategoryarr = [getCartegoryModel]()
    var imgbaseurl = "https://demo4app.com/dawadawa/public/front_assets/assets/media/category_image/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.getCartListApi()
        
        viewUpper.clipsToBounds = true
        viewUpper.layer.cornerRadius = 10
        viewUpper.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.viewUpper.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    // MARK: - Life Cycle
    
    
    
    //    TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCategoryarr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableviewSelectCategory.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell") as! SelectCategoryTableViewCell
        
        let obj = self.getCategoryarr[indexPath.row]
        cell.SelectCategoryLabel.text = obj.category_name
        
        let url = imgbaseurl + obj.cat_image!
        cell.SelectCategoryImage.sd_setImage(with: URL(string: url), placeholderImage: nil)
        
        //        let url = imgbaseurl + self.getCategoryarr[indexPath.row].cat_image
        //        cell.SelectCategoryImage.downlodeImage(serviceurl: url, placeHolder: nil)
        //
        //        debugPrint("image.........",cell.SelectCategoryImage.downlodeImage(serviceurl: url, placeHolder: nil))
        //        cell.SelectCategoryImage.image = obj.cat_image
        return cell
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "RockPitOpportunityVC") as? RockPitOpportunityVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "TrailingOpportunityVC") as? TrailingOpportunityVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "MiningBusinessVC") as? MiningBusinessVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "MiningServiceVC") as? MiningServiceVC
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        default: break
            
            
        }
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}



// MARK: - Api call


extension SelectCategoryVC{
    func getCartListApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetcategory, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
                        self.getCategoryarr = Categories.map{getCartegoryModel(data: $0)}
                        DispatchQueue.main.async {
                            self.tableviewSelectCategory.reloadData()
                        }
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
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

extension SelectCategoryVC{
    func setuplanguage(){
        lblSelectCategory.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select Category", comment: "")
    }
}
