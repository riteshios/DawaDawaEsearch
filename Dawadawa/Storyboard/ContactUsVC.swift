//  ContactUsVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 04/07/22.

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift

class ContactUsVC: UIViewController{
    
//    MARK: - Properties  -
    
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var lblSelectqueryType: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtview: IQTextView!
    
    //    MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.viewSend.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    //    MARK: - @IBAction and Methods -
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectqueryTapped(_ sender: UIButton) {
        let dataSource1 = ["Regarding subscription","Regarding opportunity issues","Regarding account issues","Regarding payment issues"]
        let dataSource2 = ["بخصوص الاشتراك" , "بخصوص مشكلات الفرصة" , "بخصوص مشكلات الحساب" , "بخصوص مشكلات الدفع"]
        
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropdown)
            {(Index ,item) in
                self.lblSelectqueryType.text = item
                
            }
        }
        else{
            kSharedAppDelegate?.dropDown(dataSource:dataSource2 , text: btnDropdown)
            {(Index ,item) in
                self.lblSelectqueryType.text = item
            }
        }
    }
    
    @IBAction func btnphonenumberTapped(_ sender: UIButton){
        let phoneNumber = "+9668465955645"
        let numberUrl = URL(string: "tel://\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        }
    }
    
    @IBAction func btnEmailAddTapped(_ sender: UIButton){
        let email = "support@dawadawa.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func btnOpenMapTapped(_ sender: UIButton){
        let lat = 12.8628
        let lon = 30.2176

        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=loc:\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(lon)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Localisation -

extension ContactUsVC{
    func setuplanguage(){
        lblContactUs.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Contact Us", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you have anything to say? Connect with us!", comment: "")
        lblSelectqueryType.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select query type", comment: "")
        txtview.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Message", comment: "")
        btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send", comment: ""), for: .normal)
    }
}
