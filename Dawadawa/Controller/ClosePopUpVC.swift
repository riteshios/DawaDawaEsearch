//
//  ClosePopUpVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/07/22.

import UIKit
class ClosePopUpVC: UIViewController {
    
    var callback:((String)->())?
    @IBOutlet weak var lblCloseOpp: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()

    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callback?("Close")
    }
}
extension ClosePopUpVC{
    func setuplanguage(){
        lblCloseOpp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close Opportunity", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to close this opportunity?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblClose.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: "")
    }
}
