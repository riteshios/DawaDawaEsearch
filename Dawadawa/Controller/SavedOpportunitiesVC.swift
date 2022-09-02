//
//  SavedOpportunitiesVC.swift
//  Dawadawa
//
//  Created by Alekh on 09/08/22.
//

import UIKit

class SavedOpportunitiesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var CollectionViewSave: UICollectionView!
    
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getallsaveopportunity()
    }
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.tabBarController?.selectedIndex = 4
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnViewAllTapped(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: ViewAllSavedVC.getStoryboardID()) as! ViewAllSavedVC
        vc.imgUrl = self.imgUrl
        vc.userTimeLine = self.userTimeLine
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userTimeLine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewSave.dequeueReusableCell(withReuseIdentifier: "SaveOpportunityCollectionViewCell", for: indexPath) as! SaveOpportunityCollectionViewCell
        let obj = userTimeLine[indexPath.row]
        
        debugPrint("obj......",obj)
        cell.lblTitle.text = String.getString(obj.title)
        cell.imgsave.downlodeImage(serviceurl: "\(imgUrl)\(String.getString(obj.oppimage.first?.imageurl))", placeHolder: UIImage(named: "truck"))
        
        return cell
    }
}


extension SavedOpportunitiesVC{
    
    //    SaveOpportunity List
    
    func getallsaveopportunity(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        //        debugPrint("\(ServiceName.kgetallopportunity)/\(UserData.shared.id)") //passing userid in api url
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetsaveOppList, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { [self] (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        
                        self.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("Dataallpost=\(self.userTimeLine)")
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        self.CollectionViewSave.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self.userTimeLine.removeAll()
                        self.CollectionViewSave.reloadData()
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
