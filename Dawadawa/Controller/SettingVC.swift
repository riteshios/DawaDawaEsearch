//  SettingVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 21/06/22.

import UIKit
class SettingVC: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet weak var lblDropDownMenu: UILabel!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var imgDropDownMenu: UIImageView!
    @IBOutlet weak var btndrop: UIButton!
    
    @IBOutlet weak var lblAboutus: UILabel!
    @IBOutlet weak var lblSubscription: UILabel!
    @IBOutlet weak var lbltermsamdcondition: UILabel!
    @IBOutlet weak var lblprivacypolicy: UILabel!
    @IBOutlet weak var lblFaq: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setup()
    }
    
    func setup(){
        
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            self.imgDropDownMenu.image = UIImage(named: "IND")
            self.lblDropDownMenu.text = "English-IND"
        }
        else{
            self.imgDropDownMenu.image = UIImage(named: "sudan")
            self.lblDropDownMenu.text = "عربي"
        }
    }
    
    //    MARK: - @IBActions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDropTapped(_ sender: UIButton) {
        let dataSource1 = ["English-IND","Arabic"]
        kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btndrop)
        {(Index ,item) in
            self.lblDropDownMenu.text = item
            self.imgDropDownMenu.image = item == "English-IND" ? UIImage(named: "IND") : UIImage(named: "sudan")
            
            if self.lblDropDownMenu.text == "English-IND"{
                self.setupUpdateView(languageCode: "en")
                kSharedUserDefaults.setLanguage(language: "en")
                self.setuplanguage()
                kSharedAppDelegate?.makeRootViewController()
                
                //                       UserDefaults.standard.set("en", forKey: "Language")
                //                       UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
            else if self.lblDropDownMenu.text == "Arabic"{
                self.setupUpdateView(languageCode: "ar")
                kSharedUserDefaults.setLanguage(language: "ar")
                self.setuplanguage()
                kSharedAppDelegate?.makeRootViewController()
                //                       UserDefaults.standard.set("ar", forKey: "Language")
                //                       UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        }
       
    }
    
    func setupUpdateView(languageCode code: String){
        LocalizationSystem.sharedInstance.setLanguage(languageCode: code)
        UIView.appearance().semanticContentAttribute =  code == "ar" ? .forceRightToLeft :  .forceLeftToRight
        
    }
    
    @IBAction func btnAboutUs(_ sender: UIButton) {
        self.AboutusApi()
        //        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        //        {return}
        //           vc.strurl = "https://demo4app.com/dawadawa/api-about"
        //           vc.head = "About Us"
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnSubscriptionTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MysubscriptionVC.getStoryboardID()) as! MysubscriptionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btntermsandCondition(_ sender: UIButton) {
        self.TermsAndConditionAPi()
        //        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        //        {return}
        //           vc.strurl = "https://demo4app.com/dawadawa/api-terms"
        //           vc.head = "Terms and Condition"
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func btnPrivacyPolicyTapped(_ sender: UIButton) {
        self.PrivacyPolicyApi()
    }
    @IBAction func btnFAQTapped(_ sender: UIButton) {
        self.FAQApi()
        //        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        //        {return}
        //        vc.strurl = "https://demo4app.com/dawadawa/api-faq"
        //        vc.head = "FAQ"
        //        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension SettingVC{
    
    //   AboutUsAPi
    
    func AboutusApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kAboutUs, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
                        {return}
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
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
    
    //   TermsandConditionAPI
    func TermsAndConditionAPi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.ktermsandcondition, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
                        {return}
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
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
    
    //    PrivacyPolicyApi
    
    func PrivacyPolicyApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kprivacypolicy, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
                        {return}
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
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
    
    // FAQApi
    func FAQApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kFaq, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let url = String.getString(dictResult["page_url"])
                        let pagename = String.getString(dictResult["page_name"])
                        debugPrint("page_url====",url)
                        
                        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
                        {return}
                        vc.strurl = url
                        vc.head = pagename
                        self.navigationController?.pushViewController(vc, animated: false)
                        
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

extension SettingVC{
    func setuplanguage(){
        lblSetting.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Settings", comment: "")
        lblAboutus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "About Us", comment: "")
        lblSubscription.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Subscriptions", comment: "")
        lbltermsamdcondition.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Terms & Conditions", comment: "")
        lblprivacypolicy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Privacy Policy", comment: "")
        lblFaq.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "FAQ’s", comment: "")
        
    }

}
