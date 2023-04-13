//  LoginSubscriptionPlanVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 09/12/22.

import UIKit

class LoginSubscriptionPlanVC: UIViewController {
    
//    MARK: - Properties -
    
    @IBOutlet weak var viewbtn: UIView!
    @IBOutlet weak var viewSkipForNow: UIView!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var btnBuyPlan: UIButton!
    @IBOutlet weak var btnSkipNow: UIButton!
    
    //    MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewbtn.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.viewSkipForNow.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setuplanguage()
    }
    
//    MARK: - @IBAction -
    
    
    @IBAction func btnHelpTapped(_sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewVC.getStoryboardID()) as! WebViewVC
               vc.strurl = "https://demo4esl.com/dawadawa/about"
//               vc.head = "Terms and Condition"
               self.navigationController?.pushViewController(vc, animated: false)
       
    }
    
    @IBAction func btnLogoutTapped(_sender: UIButton){
        UserData.shared.saveData(data: [:], token: "" )
        print("\(UserData.shared.saveData(data: [:], token: "" ))")
        
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeScreenVC") as! WelcomeScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBuyplanTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BuyPlanVC") as! BuyPlanVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSkipfornow(_ sender: UIButton){
        kSharedUserDefaults.getLoggedInUserDetails()
        kSharedAppDelegate?.makeRootViewController()
        
    }
    
}

//    MARK: - Localization -

extension LoginSubscriptionPlanVC{
    
    func setuplanguage(){
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Welcome To DawaDawa", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "To Visit and run the DawaDawa App You Should Take Subscription plan. These Details are Under Help Section To Take the Plan Click on Buy Subscription Button", comment: "")
        btnHelp.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Help", comment: ""), for: .normal)
        btnLogOut.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Logout", comment: ""), for: .normal)
        btnBuyPlan.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Buy plans", comment: ""), for: .normal)
        btnSkipNow.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Skip for now", comment: ""), for: .normal)
    }
}
