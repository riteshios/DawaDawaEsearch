//
//  FilterVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/07/22.
//

import UIKit
import RangeSeekSlider

class FilterVC: UIViewController {

    @IBOutlet weak var PriceSlider: RangeSeekSlider!
    
    @IBOutlet weak var tblViewOpportunitytype: UITableView!
    @IBOutlet weak var tblViewServicetype: UITableView!
    
    
    var getCategoryarr = [getCartegoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidersetup()
        self.setup()
        self.getCartListApi()
    }
    
    private func setup(){
        tblViewOpportunitytype.register(UINib(nibName: "OpportunityTypeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OpportunityTypeTableViewCell")
        tblViewOpportunitytype.register(UINib(nibName: "SubCategorylabelTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubCategorylabelTableViewCell")
        tblViewOpportunitytype.register(UINib(nibName: "SubcategoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubcategoryTableViewCell")
    }
    
    private func slidersetup() {

        PriceSlider.delegate = self
        PriceSlider.minValue = 0.0
        PriceSlider.maxValue = 100.0
        PriceSlider.selectedMinValue = 40.0
        PriceSlider.selectedMaxValue = 60.0
        PriceSlider.handleImage = #imageLiteral(resourceName: "Star Filled")
        PriceSlider.selectedHandleDiameterMultiplier = 1.0
        PriceSlider.colorBetweenHandles = .red
        PriceSlider.lineHeight = 10.0
        PriceSlider.numberFormatter.positivePrefix = "$"
        PriceSlider.numberFormatter.positiveSuffix = "M"
    }
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
  

}

// MARK: - Table View Delegate
extension FilterVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView{
        case tblViewOpportunitytype:
            return 3
        case tblViewServicetype:
            return 1
        
        default: return 0
        }
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case tblViewOpportunitytype:
            switch section{
            case 0:
                return self.getCategoryarr.count
                
            case 1:
                return 1

            case 2:
                return 10
                
                
            default:
                return 0
            }
        case tblViewServicetype:
            return 10
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case tblViewOpportunitytype:
            switch indexPath.section{
            case 0:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "OpportunityTypeTableViewCell") as! OpportunityTypeTableViewCell
                let obj = self.getCategoryarr[indexPath.row]
                cell.lblCategory.text = obj.category_name
                return cell
            case 1:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubCategorylabelTableViewCell") as! SubCategorylabelTableViewCell
                return cell

            case 2:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubcategoryTableViewCell") as! SubcategoryTableViewCell
                return cell
            default:
                return UITableViewCell()
            }
        case tblViewServicetype:
            let cell = self.tblViewServicetype.dequeueReusableCell(withIdentifier: "ServiceTypeTableViewCell", for: indexPath) as! ServiceTypeTableViewCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case tblViewOpportunitytype:
            switch indexPath.section{
            case 0:
                return 60
            case 1:
                return UITableView.automaticDimension
            case 2:
                return UITableView.automaticDimension
            
            default:
                return 0
            }
        case tblViewServicetype:
            return 60
            
        default:
            return 0
        }
      
        
    }
    
    
    
}
// MARK: - RangeSeekSliderDelegate

extension FilterVC: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === PriceSlider {
            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
// MARK: - Api call


extension FilterVC{
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
                            self.tblViewOpportunitytype.reloadData()
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
