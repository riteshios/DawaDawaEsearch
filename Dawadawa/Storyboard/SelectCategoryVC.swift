//
//  SelectCategoryVC.swift
//  Dawadawa
//
//  Created by Alekh on 07/07/22.
//

import UIKit
import CoreMedia

class SelectCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
//    MARK: - Properties
    var animals: [String] = ["Horse", "Cow", "Camel"]
    var arrimage = [UIImage(named: "IND"),UIImage(named: "IND"),UIImage(named: "IND")]
    var getCategoryarr = [getCartegoryModel]()
    
    
    @IBOutlet weak var tableviewSelectCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCartListApi()

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
    
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.kgetcategory, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                    else if  Int.getInt(dictResult["status"]) == 400{
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
