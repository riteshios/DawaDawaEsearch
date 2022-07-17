//
//  SelectCategoryVC.swift
//  Dawadawa
//
//  Created by Alekh on 07/07/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreMedia
import SKFloatingTextField
import SDWebImage

class SelectCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    MARK: - Properties
    
    

    
    
    @IBOutlet weak var tableviewSelectCategory: UITableView!
    
    var getCategoryarr = [getCartegoryModel]()
    var imgbaseurl = "https://demo4app.com/dawadawa/public/front_assets/assets/media/category_image/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getcategoryapi()
        self.getCartListApi()
        
       
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
    
    
    
//    func getcategoryapi(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//        categoryapi(language: "en") { success, catdata, baseurl, message in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if success == 200{
//                if let catdata = catdata {
//                    self.getCategoryarr = catdata
//                    self.imgbaseurl = "https://demo4app.com/dawadawa/public/front_assets/assets/media/category_image/"
//                    print(self.getCategoryarr)
//                    self.tableviewSelectCategory.reloadData()
//                }
//            }
//            else{
//                CommonUtils.showError(.error, String.getString(message))
//            }
//            
//        }
//        
//    }
    
}
//extension SelectCategoryVC{
//    func categoryapi(language:String, completionBlock: @escaping (_ success: Int, _ catdata : [getCartegoryModel]?, _ baseurl: String,_ message: String) -> Void) {
//
//
//        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
//        debugPrint("headers......\(headers)")
//
//        var params = Dictionary<String, String>()
//
//        //
//        let url = kBASEURL + ServiceName.kgetcategory
//        //
//        //        print("============\(params)")
//        print(url)
//
//        Alamofire.request(url,method: .get, parameters : params, headers: headers).responseJSON { response in
//            switch response.result {
//            case.success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//
//                    print(" team Details json is:\n\(json)")
//
//                    let parser = getCategoryParser(json: json)
//
//
//                    completionBlock(parser.status,parser.Categories,parser.baseurl,parser.message)
//                }else{
//                    completionBlock(0,nil,"",response.result.error?.localizedDescription ?? "Some thing went wrong")
//                }
//
//            case .failure(let error):
//                completionBlock(0,nil,"",error.localizedDescription)
//            }
//
//        }
//    }
//    //    parser
//    class getCategoryParser : NSObject{
//
//        let KResponsecode = "responsecode"
//        let kStatus = "status"
//        let kMessage = "message"
//        let kCategories = "Categories"
//        let kbaseurl = "base_url"
//
//
//        var responsecode = 0
//        var status = 0
//        var baseurl = ""
//        var message = ""
//        var Categories =  [getCartegoryModel]()
//
//        override init() {
//            super.init()
//        }
//        init(json: JSON) {
//            if let responsecode = json[KResponsecode].int as Int?{
//                self.responsecode = responsecode
//            }
//            if let status = json[kStatus].int as Int?{
//                self.status = status
//            }
//            if let message = json[kMessage].string as String?{
//                self.message = message
//            }
//            if let baseurl = json[kbaseurl].string as String?{
//                self.baseurl = baseurl
//            }
//
//
//            if let passingData = json[kCategories].arrayObject as? Array<Dictionary<String, AnyObject>>{
//
//                for item in passingData {
//                    let Faq = getCartegoryModel(dictionary: item)
//                    self.Categories.append(Faq)
//                }
//            }
//            super.init()
//        }
//    }
//}
