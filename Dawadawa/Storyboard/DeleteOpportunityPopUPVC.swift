//  DeleteOpportunityPopUPVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/07/22.


import UIKit

class DeleteOpportunityPopUPVC: UIViewController {
    
    @IBOutlet weak var lblDeleteOpp: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewDelete: UIView!
    
    
    var callback:((String)->())?
    
//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if viewBG == touch.view{
                self.dismiss(animated: true)
            }
        }
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("Delete")
    }
}

// MARK: - Localisation

extension DeleteOpportunityPopUPVC{
    func setuplanguage(){
        lblDeleteOpp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Opportunity", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to delete this opportunity?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: "")
    }
}
