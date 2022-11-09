//
//  FlagPostPopUPVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 08/11/22.
//

import UIKit
import IQKeyboardManagerSwift

class FlagPostPopUPVC: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var textviewReason: IQTextView!
    var oppid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        
    }
    
    @IBAction func btndismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReportTapped(_ sender: UIButton) {
        if self.textviewReason.text == ""{
            self.showSimpleAlert(message: "Please Enter Reason for Flag")
        }
        else{
            self.flagopportunityapi()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    

    // Api flag Opportunity
    
    func flagopportunityapi(){
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        let params:[String : Any] = [
            "opr_id":self.oppid,
            "user_id":UserData.shared.id,
            "reason":self.textviewReason.text
        ]
        
        debugPrint("oppid......",self.oppid)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kflagpost, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
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
                        
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        //                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        //                        kSharedAppDelegate?.makeRootViewController()
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
}
