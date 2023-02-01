//  ContactUsVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 04/07/22.

import UIKit
import GoogleMaps

class ContactUsVC: UIViewController {
    
    @IBOutlet weak var viewSend: UIView!
    
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var lblSelectqueryType: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var Mapview: GMSMapView!
    
    
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.viewSend.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        Mapview = GMSMapView.map(withFrame: .zero, camera: GMSCameraPosition.camera(withLatitude: 12.862807, longitude: 30.217636, zoom: 5.5))

                //so the mapView is of width 200, height 200 and its center is same as center of the self.view
//        Mapview?.center = self.view.center

//                self.view.addSubview(Mapview)
    }
    
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectqueryTapped(_ sender: UIButton) {
        let dataSource1 = ["Select query Type1","Select query Type2","Select query Type3","Select query Type4"]
        kSharedAppDelegate?.dropDown(dataSource:dataSource1 , text: btnDropdown)
        {(Index ,item) in
            self.lblSelectqueryType.text = item
            
        }
    }
    
    @IBAction func btnphonenumberTapped(_ sender: UIButton){
        let phoneNumber = "+966 8465 9556 45"
//        let numberUrl = URL(string: "tel://\(phoneNumber)")
//        if UIApplication.shared.canOpenURL((numberUrl)!) {
//            UIApplication.shared.open((numberUrl)!)
//            print("dialer=-=-")
//        }
        
        if let url = URL(string: "tel://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnEmailAddTapped(_ sender: UIButton){
        
    }
}

// MARK: - Localisation

extension ContactUsVC{
    func setuplanguage(){
        lblContactUs.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Contact Us", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you have anything to say? Connect with us!", comment: "")
        lblSelectqueryType.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select query type", comment: "")
        btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Send", comment: ""), for: .normal)
    }
}
