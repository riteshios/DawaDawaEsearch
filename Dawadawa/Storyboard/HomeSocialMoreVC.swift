//  HomeSocialMoreVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/07/22.

import UIKit

class HomeSocialMoreVC: UIViewController {
    
//    MARK: - Properties -
    
    var callback:((String)->())?
    @IBOutlet weak var Viewmain: UIView!
    @IBOutlet weak var viewBG:UIView!
    @IBOutlet weak var lblChatwithuser: UILabel!
    @IBOutlet weak var lblCopylink: UILabel!
    @IBOutlet weak var lblMarkasinter: UILabel!
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblReportUSer: UILabel!
    @IBOutlet weak var lblViewDetails: UILabel!
    
    @IBOutlet weak var viewViewDetails: UIView!
    @IBOutlet weak var HeightviewMain: NSLayoutConstraint!
    var hascamefrom = ""
    
//    MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setup()
        if hascamefrom == "DetailPage"{
            self.viewViewDetails.isHidden = true
            self.HeightviewMain.constant = 370
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if viewBG == touch.view{
                self.dismiss(animated: true)
            }
        }
    }
    
    func setup(){
        Viewmain.clipsToBounds = true
        Viewmain.layer.cornerRadius = 25
        Viewmain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Viewmain.addShadowWithBlurOnView(Viewmain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
//    MARK: - @IBAction and Methods -
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
//        self.callback?("Dismiss")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnChatwithuserTapped(_ sender: UIButton){
        self.callback?("Chatwithuser")
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        self.callback?("CopyLink")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnMarkasinterestedTapped(_ sender: UIButton){
        self.callback?("MarkasInterested")
    }
    
    @IBAction func btnFlagPostTapped(_ sender: UIButton) {
        self.callback?("Flag")
    }
    
    @IBAction func btnReportUserTapped(_ sender: UIButton) {
        self.callback?("Report")
    }
    
    @IBAction func btnViewDetails(_ sender: UIButton) {
        self.callback?("viewdetails")
    }
}
//    MARK: - Localisation -

extension HomeSocialMoreVC{
    func setuplanguage(){
        lblChatwithuser.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Chat with user", comment: "")
        lblCopylink.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Copy link", comment: "")
        lblMarkasinter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mark as interested", comment: "")
        lblFlag.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Flag post", comment: "")
        lblReportUSer.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Report user", comment: "")
        lblViewDetails.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "View Details", comment: "")
    }
}
