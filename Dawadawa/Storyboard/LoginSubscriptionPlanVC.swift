//  LoginSubscriptionPlanVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 09/12/22.

import UIKit

class LoginSubscriptionPlanVC: UIViewController {
    
    @IBOutlet weak var viewbtn: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewbtn.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
//    MARK: - @IBAction
    
    
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
