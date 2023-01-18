//  RateOpportunityPopUPVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/09/22.

import UIKit
import Cosmos

class RateOpportunityPopUPVC: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet weak var Viewmain: UIView!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var viewBG:UIView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var RatingSlider: UISlider!
    
    @IBOutlet weak var lblRatingatheading: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    private let startRating: Float = 3.7
    var callbackClosure:(()->())?
    
    
    var oppid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    MARK: -------- view controller lifecycle ----------
        
        self.setup()
        self.setuplanguage()
        viewRating.settings.starSize = 30
        viewRating.settings.starMargin = 4
        viewRating.settings.fillMode = .precise
        // Register touch handlers
        viewRating?.didTouchCosmos = didTouchCosmos
        viewRating?.didFinishTouchingCosmos = didFinishTouchingCosmos
        //update with initial data
        RatingSlider?.value = startRating
        updateRating(requiredRating: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if viewBG == touch.view{
                self.dismiss(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        callbackClosure?()
    }
    
    func setup(){
        Viewmain?.clipsToBounds = true
        Viewmain?.layer.cornerRadius = 25
        Viewmain?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Viewmain?.addShadowWithBlurOnView(Viewmain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewSubmit?.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
    }
    
    //    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
//        self.callback?("Dismiss")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.rateopportunityapi()
        self.dismiss(animated: true)
        
    }
    
    private func updateRating(requiredRating: Double?) {
        var newRatingValue: Double = 0
        
        if let nonEmptyRequiredRating = requiredRating {
            newRatingValue = nonEmptyRequiredRating
        } else {
            newRatingValue = Double(RatingSlider?.value ?? 0)
        }
        
        viewRating?.rating = newRatingValue
        
        self.lblRating?.text = RateOpportunityPopUPVC.formatValue(newRatingValue)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        RatingSlider?.value = Float(rating)
        updateRating(requiredRating: rating)
        lblRating?.text = RateOpportunityPopUPVC.formatValue(rating)
        lblRating?.textColor = UIColor(red: 133/255, green: 116/255, blue: 154/255, alpha: 1)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        RatingSlider?.value = Float(rating)
        self.lblRating?.text = RateOpportunityPopUPVC.formatValue(rating)
        lblRating?.textColor = UIColor(red: 183/255, green: 186/255, blue: 204/255, alpha: 1)
    }
}

extension RateOpportunityPopUPVC{
    
    // Api rate Opportunity
    
    func rateopportunityapi(){
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        debugPrint("RatingStarCount=-=-=-",self.lblRating.text)
        debugPrint("opr_id=-=-=-",self.oppid)
        
        let params:[String : Any] = [
            "user_id":String.getString(UserData.shared.id),
            "opr_id":String.getString(self.oppid),
            "rating_star_count":String.getString(self.lblRating.text),
            "message":"Rated"
        ]
        
        debugPrint("opr_id......",self.oppid)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.krateopp, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
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
//                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
}

extension RateOpportunityPopUPVC{
    
    func setuplanguage(){
        lblRatingatheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rating", comment: "")
        btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Submit", comment: ""), for: .normal)
    }
}
