//
//  SettingVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/06/22.
//

import UIKit
import Localize_Swift



class SettingVC: UIViewController {
    
//    MARK: - Properties

    @IBOutlet weak var lblDropDownMenu: UILabel!
    @IBOutlet weak var imgDropDownMenu: UIImageView!
    @IBOutlet weak var btndrop: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func btnDropTapped(_ sender: UIButton) {
        let dataSource1 = ["English-IND","Arabic"]
               kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btndrop)
               {(Index ,item) in
                   self.lblDropDownMenu.text = item
                   self.imgDropDownMenu.image = item == "English-IND" ? UIImage(named: "IND") : UIImage(named: "sudan")
                   if self.lblDropDownMenu.text == "English-IND"{
                       UserDefaults.standard.set("en", forKey: "Language")
//                       Localize.setCurrentLanguage("en")
                       UIView.appearance().semanticContentAttribute = .forceLeftToRight
                   }
                   else if self.lblDropDownMenu.text == "Arabic"{
                       UserDefaults.standard.set("ar", forKey: "Language")
//                       Localize.setCurrentLanguage("ar")
                       UIView.appearance().semanticContentAttribute = .forceRightToLeft
                   }
    }
}
    @IBAction func btntermsandCondition(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        {return}
           vc.strurl = "https://demo4app.com/dawadawa/api-terms"
           vc.head = "Terms and Condition"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAboutUs(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        {return}
           vc.strurl = "https://demo4app.com/dawadawa/api-about"
           vc.head = "About Us"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnFAQTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else
        {return}
        vc.strurl = "https://demo4app.com/dawadawa/api-faq"
        vc.head = "FAQ"
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
