
//  SavedOpportunitiesVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 09/08/22.


import UIKit

class SavedOpportunitiesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var lblSaved:UILabel!
    @IBOutlet weak var btnViewAllSaved:UIButton!
    @IBOutlet weak var btnViewAllInterested: UIButton!

    @IBOutlet weak var CollectionViewSave: UICollectionView!
    @IBOutlet weak var CollectionViewInterested: UICollectionView!
    
    @IBOutlet weak var imgNoOpp: UIImageView!
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imgNoOpp.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getallsaveopportunity()
        self.getallinterestedopportunityapi()
    }
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.tabBarController?.selectedIndex = 4
        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnViewAllTSavedapped(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: ViewAllSavedVC.getStoryboardID()) as! ViewAllSavedVC
        vc.imgUrl = self.imgUrl
        vc.userTimeLine = self.userTimeLine
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnViewAllInterestedTapped(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: ViewAllInterestedVC.getStoryboardID()) as! ViewAllInterestedVC
        vc.imgUrl = self.imgUrl
        vc.userTimeLine = self.userTimeLine
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
            
        case CollectionViewSave:
            return userTimeLine.count
        case CollectionViewInterested:
            return userTimeLine.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case CollectionViewSave:
            let cell = CollectionViewSave.dequeueReusableCell(withReuseIdentifier: "SaveOpportunityCollectionViewCell", for: indexPath) as! SaveOpportunityCollectionViewCell
            let obj = userTimeLine[indexPath.row]
            
            debugPrint("obj......",obj)
            cell.lblTitle.text = String.getString(obj.title)
            cell.imgsave.downlodeImage(serviceurl: "\(imgUrl)\(String.getString(obj.oppimage.first?.imageurl))", placeHolder: UIImage(named: "truck"))
            return cell
            
        case CollectionViewInterested:
            
            let cell = CollectionViewInterested.dequeueReusableCell(withReuseIdentifier: "SaveOpportunityCollectionViewCell", for: indexPath) as! SaveOpportunityCollectionViewCell
            let obj = userTimeLine[indexPath.row]
            
            debugPrint("obj......",obj)
            cell.lblTitle.text = String.getString(obj.title)
            cell.imgsave.downlodeImage(serviceurl: "\(imgUrl)\(String.getString(obj.oppimage.first?.imageurl))", placeHolder: UIImage(named: "truck"))
            return cell
            
        default:
            return UICollectionViewCell()
        }
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
                        
                        
                        self.imgNoOpp.isHidden = true
                        self.CollectionViewSave.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        self.userTimeLine.removeAll()
                        self.CollectionViewSave.reloadData()
//                        self.lblSaved.isHidden = true
                        self.btnViewAllSaved.isHidden = true
                        self.imgNoOpp.isHidden = false
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
    
    //    MarkinterestedOppList
    
    func getallinterestedopportunityapi(){
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetinterestedOppList, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { [self] (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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
                        print("Dataallinterested=\(self.userTimeLine)")
                        self.CollectionViewInterested.reloadData()
                        
                    }
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
//                        self.userTimelineInterested.removeAll()
//                        self.CollectionViewInterested.reloadData()
//                        self.lblSaved.isHidden = true
//                        self.btnViewAllSaved.isHidden = true
//                        self.imgNoOpp.isHidden = false
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
