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

class SelectCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
//    MARK: - Properties
    var animals: [String] = ["Horse", "Cow", "Camel"]
    var arrimage = [UIImage(named: "IND"),UIImage(named: "IND"),UIImage(named: "IND")]
    var getCategoryarr = [getCartegoryModel]()
    
    
    
    @IBOutlet weak var tableviewSelectCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getcategoryapi()

        // Do any additional setup after loading the view.
    }
    
// MARK: - Life Cycle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCategoryarr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableviewSelectCategory.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell") as! SelectCategoryTableViewCell
//        cell.SelectCategoryLabel?.text = self.animals[indexPath.row]
//        cell.SelectCategoryImage.image = self.arrimage[indexPath.row]
        let obj = self.getCategoryarr[indexPath.row]
        cell.SelectCategoryLabel.text = obj.category_name
        return cell
        
return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "RockPitOpportunityVC") as? RockPitOpportunityVC
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Api call


extension SelectCategoryVC{
//    func getCartListApi(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
//            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
//            let septoken = endToken.components(separatedBy: " ")
//            if septoken[0] != "Bearer"{
//                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
//                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
//            }
//        }
//
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kgetcategory, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if errorType == .requestSuccess {
//                let dictResult = kSharedInstance.getDictionary(result)
//                switch Int.getInt(statusCode) {
//                case 200:
//                    if Int.getInt(dictResult["status"]) == 200{
//                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
//                        let septoken = endToken.components(separatedBy: " ")
//                        if septoken[0] == "Bearer"{
//                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
//                        }
//
//                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
//                        self.getCategoryarr = Categories.map{getCartegoryModel(data: $0)}
//                        DispatchQueue.main.async {
//                        self.tableviewSelectCategory.reloadData()
//                        }
//                    }
//                    else if  Int.getInt(dictResult["status"]) == 400{
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
//                    }
//
//                   // CommonUtils.showError(.info, String.getString(dictResult["message"]))
//                default:
//                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
//                }
//            }else if errorType == .noNetwork {
//                CommonUtils.showToastForInternetUnavailable()
//
//            } else {
//                CommonUtils.showToastForDefaultError()
//            }
//        }
//    }
    func getcategoryapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        categoryapi(language: "en") { success, catdata, baseurl, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if success == 200{
                if let catdata = catdata {
                    self.getCategoryarr = catdata
                    print(self.getCategoryarr)
                    self.tableviewSelectCategory.reloadData()
                }
            }
            else{
                CommonUtils.showError(.error, String.getString(message))
            }
        }
        
    }
    
}
extension SelectCategoryVC{
    func categoryapi(language:String, completionBlock: @escaping (_ success: Int, _ catdata : [getCartegoryModel]?, _ baseurl: String,_ message: String) -> Void) {
           
           
        let headers : HTTPHeaders = ["Authorization": kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
           
           var params = Dictionary<String, String>()
    
   //
        let url = kBASEURL + ServiceName.kgetcategory
   //
   //        print("============\(params)")
           print(url)
           
           Alamofire.request(url,method: .get, parameters : params, headers: headers).responseJSON { response in
               switch response.result {
               case.success:
                   if let value = response.result.value {
                       let json = JSON(value)
                       
                       print(" team Details json is:\n\(json)")
                     
                       let parser = getCategoryParser(json: json)
                       
                       
                       completionBlock(parser.status,parser.Categories,parser.baseurl,parser.message)
                   }else{
                       completionBlock(0,nil,"",response.result.error?.localizedDescription ?? "Some thing went wrong")
                   }
                   
               case .failure(let error):
                   completionBlock(0,nil,"",error.localizedDescription)
               }
               
           }
       }
    class getCategoryParser : NSObject{
       
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let kCategories = "Categories"
        let kbaseurl = "base_url"
       
        
        var responsecode = 0
        var status = 0
        var message = ""
        var baseurl = ""

        var Categories =  [getCartegoryModel]()
        
        override init() {
            super.init()
        }
        init(json: JSON) {
            if let responsecode = json[KResponsecode].int as Int?{
                self.responsecode = responsecode
            }
            if let status = json[kStatus].int as Int?{
                self.status = status
            }
            if let message = json[kMessage].string as String?{
                self.message = message
            }
            
            
            if let passingData = json[kCategories].arrayObject as? Array<Dictionary<String, AnyObject>>{
              
                for item in passingData {
                    let Faq = getCartegoryModel(dictionary: item)
                    self.Categories.append(Faq)
                }
            }
            super.init()
        }
    }
}