//
//  PaymentForFeatureandPremiumPopUPVC.swift
//  Dawadawa
//
//  Created by Alekh on 19/10/22.
//

import UIKit

class PaymentForFeatureandPremiumPopUPVC: UIViewController {
    
    var callback:((String)->())?
    var plan = 0
    var planamount:plan_amount?
    
    @IBOutlet weak var lblAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getplan_amountyapi()
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnProceedtoPayTapped(_ sender: UIButton) {
        self.callback?("Pay")
    }
    
}

extension PaymentForFeatureandPremiumPopUPVC {
    //     Api call
    
    func getplan_amountyapi(){
        CommonUtils.showHudWithNoInteraction(show: true)

        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }

        let url =  ServiceName.kgetplanamount + "\(self.plan)"
        debugPrint("urlplanamount==",url)

        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: url, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { [self] (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
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

                        let data = kSharedInstance.getDictionary(dictResult["data"])
                        self.planamount = plan_amount(data: data)
                        print("Dataplanamount=\(self.planamount)")

                        self.lblAmount.text = String.getString("Payment: - $\(Int((self.planamount?.amount) ?? 0))")
                        
                    }

                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
