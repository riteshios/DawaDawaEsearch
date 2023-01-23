//  WelcomeScreenVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.

import UIKit

class WelcomeScreenVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRegister: UIView!
    
    @IBOutlet weak var lblDawadawa: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lbllogin: UILabel!
    @IBOutlet weak var lblregister: UILabel!
    @IBOutlet weak var btnSkiplogin: UIButton!
    
    @IBOutlet weak var btndrop: UIButton!
    @IBOutlet weak var lblDropDownMenu: UILabel!
    @IBOutlet weak var imgDropDownMenu: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
//     MARK: - Life Cycle
    func setup(){
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
//        self.viewLogin.backgroundColor = UIColor(hexString: "#F1F9FD")
//        self.viewLogin.borderColor = UIColor(hexString: "#1572A1")
        self.viewLogin.cornerRadius = 10
//        self.viewRegister.backgroundColor = UIColor(hexString: "#F1F9FD")
//        self.viewRegister.borderColor = UIColor(hexString: "#1572A1")
        self.viewRegister.cornerRadius = 10
        self.viewLogin.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.viewRegister.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
            
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.imgDropDownMenu.image = UIImage(named: "IND")
                self.lblDropDownMenu.text = "English-IND"
            }
            else{
                self.imgDropDownMenu.image = UIImage(named: "sudan")
                self.lblDropDownMenu.text = "عربي"
            }
    }
    
    
//     MARK: - @IBAction
    
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreenVC") as! WelcomeScreenVC
                self.navigationController?.pushViewController(vc, animated: false)
                
//                kSharedAppDelegate?.makeRootViewController()
                
                //                       UserDefaults.standard.set("en", forKey: "Language")
                //                       UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
            else if self.lblDropDownMenu.text == "Arabic"{
                self.setupUpdateView(languageCode: "ar")
                kSharedUserDefaults.setLanguage(language: "ar")
                self.setuplanguage()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreenVC") as! WelcomeScreenVC
                self.navigationController?.pushViewController(vc, animated: false)
//                kSharedAppDelegate?.makeRootViewController()
                //                       UserDefaults.standard.set("ar", forKey: "Language")
                //                       UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        }
    }
    
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
//        if sender.isSelected == true{
//            self.viewLogin.backgroundColor = UIColor(hexString: "#1572A1")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
//            self.viewRegister.backgroundColor = UIColor(hexString: "#1572A1")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSkipTapped(_ sender: UIButton){
        UserData.shared.isskiplogin = true
        cameFrom = ""
        kSharedAppDelegate?.makeRootViewController()
    }
}
// MARK: - Localisation

extension WelcomeScreenVC{
    
    func setuplanguage(){
        lblDawadawa.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "DawaDawa", comment: "")
        lbllogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: "")
        lblregister.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Register", comment: "")
        btnSkiplogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Skip Login", comment: ""), for: .normal)
    }
    
    func setupUpdateView(languageCode code: String){
        LocalizationSystem.sharedInstance.setLanguage(languageCode: code)
        UIView.appearance().semanticContentAttribute =  code == "ar" ? .forceRightToLeft :  .forceLeftToRight
        
    }
}

