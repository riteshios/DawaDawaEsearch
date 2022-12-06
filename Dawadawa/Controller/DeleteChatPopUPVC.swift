//  DeleteChatPopUPVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 11/11/22.

import UIKit

class DeleteChatPopUPVC: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    
    var callback:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        
    }
//    MARK: - @IBAction
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.callback?("Dismiss")
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("DeleteChat")
        
    }
}
// MARK: - Localisation

extension DeleteChatPopUPVC{
    func setuplanguage(){
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete Chat", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to delete this Chat?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: "")
        
    }
}
