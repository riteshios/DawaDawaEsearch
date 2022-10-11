//
//  ContactUsVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 04/07/22.
//

import UIKit

class ContactUsVC: UIViewController {
    
    @IBOutlet weak var viewSend: UIView!
    
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var lblSelectqueryType: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSend.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
    }
    
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
}
