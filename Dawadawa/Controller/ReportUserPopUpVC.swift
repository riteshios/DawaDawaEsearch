//
//  ReportUserPopUpVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/10/22.



import UIKit

class ReportUserPopUpVC: UIViewController {
    
    @IBOutlet weak var Viewmain: UIView!
    @IBOutlet weak var TextViewReportIssue:UITextView!
    @IBOutlet weak var lblReportuser: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    
    var userid = 0
//    var reportcheck = ""
    var selectedreport = ""
    var reportcheck:[String] = []

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
    }
    
    func setup(){
        Viewmain.clipsToBounds = true
        Viewmain.layer.cornerRadius = 25
        Viewmain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Viewmain.addShadowWithBlurOnView(Viewmain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        
    }
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnReason1Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.reportcheck.append("one")
            
            let check = self.reportcheck.joined(separator: ",")
            self.selectedreport = check
            
            print("selectedreport=--=\(selectedreport)")
            
        }
        else if sender.isSelected == false{
            if reportcheck.contains("one") == true{
                self.reportcheck.removeAll{ $0 == "one"}
               
                let check = self.reportcheck.joined(separator: ",")
                self.selectedreport = check
                
                print("selectedreport=--=\(selectedreport)")
               
            }
        }
    }
    
    @IBAction func btnReason2Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.reportcheck.append("two")
            
            let check = self.reportcheck.joined(separator: ",")
            self.selectedreport = check
            
            print("selectedreport=--=\(selectedreport)")
            
        }
        else if sender.isSelected == false{
            if reportcheck.contains("two") == true{
                self.reportcheck.removeAll{ $0 == "two"}
               
                let check = self.reportcheck.joined(separator: ",")
                self.selectedreport = check
                
                print("selectedreport=--=\(selectedreport)")
               
            }
        }
    }
    
    @IBAction func btnReason3Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.reportcheck.append("three")
            
            let check = self.reportcheck.joined(separator: ",")
            self.selectedreport = check
            
            print("selectedreport=--=\(selectedreport)")
            
        }
        else if sender.isSelected == false{
            if reportcheck.contains("three") == true{
                self.reportcheck.removeAll{ $0 == "three"}
               
                let check = self.reportcheck.joined(separator: ",")
                self.selectedreport = check
                
                print("selectedreport=--=\(selectedreport)")
               
            }
        }
    }
    
    @IBAction func btnReason4Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.reportcheck.append("four")
            
            let check = self.reportcheck.joined(separator: ",")
            self.selectedreport = check
            
            print("selectedreport=--=\(selectedreport)")
            
        }
        else if sender.isSelected == false{
            if reportcheck.contains("four") == true{
                self.reportcheck.removeAll{ $0 == "four"}
               
                let check = self.reportcheck.joined(separator: ",")
                self.selectedreport = check
                
                print("selectedreport=--=\(selectedreport)")
               
            }
        }
    }
    
    @IBAction func btnReportTapped(_ sender: UIButton){
        if self.TextViewReportIssue.text == ""{
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: "The report issue field is required.")
            }
            else{
                self.showSimpleAlert(message: "حقل إصدار التقرير مطلوب")
            }
            
        }
        else{
            self.reportuserapi()
            self.dismiss(animated: true)
        }
    }
    
}

extension ReportUserPopUpVC{
    
    //    Api Report User
    
    func reportuserapi(){
        
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
            "user_id":Int.getInt(UserData.shared.id),
            "report_user_id":userid,
            "report_check":self.reportcheck,
            "report_issue":String.getString(self.TextViewReportIssue.text)
        ]
        
        debugPrint("report_check.....",self.reportcheck)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kreportuser, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                    
                    else if  Int.getInt(dictResult["responsecode"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    else if  Int.getInt(dictResult["responsecode"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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

extension ReportUserPopUpVC{
    func setuplanguage(){
        lblReportuser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Report User", comment: "")
        btnReport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Report", comment: ""), for: .normal)
    }
}
