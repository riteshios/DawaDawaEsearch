
//  DeleteOpportunityPopUPVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 22/07/22.


import UIKit

class DeleteOpportunityPopUPVC: UIViewController {
    
    @IBOutlet weak var lblDeleteOpp: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    
    var callback:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("Delete")
    }
}

extension DeleteOpportunityPopUPVC{
    func setuplanguage(){
        lblDeleteOpp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Opportunity", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to delete this opportunity?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: "")
    }
}
