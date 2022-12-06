//  SaveOpportunityMoreVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 10/08/22.


import UIKit

class SaveOpportunityMoreVC: UIViewController {
    

    var callback:((String)->())?
    
    @IBOutlet weak var lblChatwithuser: UILabel!
    @IBOutlet weak var lblCopylink: UILabel!
    @IBOutlet weak var lblFlagpost: UILabel!
    @IBOutlet weak var lblReportuser: UILabel!
    @IBOutlet weak var lblRemovedfromsaved: UILabel!

    @IBOutlet weak var Viewmain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
       
    }
    func setup(){
        Viewmain.clipsToBounds = true
        Viewmain.layer.cornerRadius = 25
        Viewmain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Viewmain.addShadowWithBlurOnView(Viewmain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
       
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
//        self.callback?("Dismiss")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnFlagPostTapped(_ sender: UIButton) {
        self.callback?("Flag")
    }
    
    @IBAction func btnReportUserTapped(_ sender: UIButton) {
        self.callback?("Report")
    }
    
    @IBAction func btnResavedTapped(_ sender: UIButton) {
        self.callback?("Unsaved")
    }
    
}
extension SaveOpportunityMoreVC{
    func setuplanguage(){
        lblChatwithuser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Chat with user", comment: "")
        lblChatwithuser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Copy link", comment: "")
        lblFlagpost.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Flag post", comment: "")
        lblReportuser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Report user", comment: "")
        lblRemovedfromsaved.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Removed from saved", comment: "")
        
    }
}
