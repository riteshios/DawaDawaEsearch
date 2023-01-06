//  ProileSocialMoreVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/07/22.

import UIKit

class ProileSocialMoreVC: UIViewController {
    
    var callback:((String)->())?

    @IBOutlet weak var Viewmain: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewViewDetails: UIView!
    
    @IBOutlet weak var lblCopylink: UILabel!
    @IBOutlet weak var lblUpdate: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    
    @IBOutlet weak var HeightviewMain: NSLayoutConstraint
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        if hascamefrom == "DetailPage"{
            self.viewViewDetails.isHidden = true
            self.HeightviewMain.constant = 320
        }
    }
    
    func setup(){
        self.setuplanguage()
        Viewmain.clipsToBounds = true
        Viewmain.layer.cornerRadius = 25
        Viewmain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Viewmain.addShadowWithBlurOnView(Viewmain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.callback?("Dismiss")
//        self.dismiss(animated: true)
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        self.callback?("CopyLink")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUpdateTapped(_ sender: UIButton) {
        self.callback?("Update")
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("Delete")
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callback?("Close")
    }
    
    @IBAction func btnViewdetails(_ sender: UIButton){
        self.callback?("ViewDetail")
    }
    

}
// MARK: - LOcalisation

extension ProileSocialMoreVC{
    func setuplanguage(){
        lblCopylink.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Copy link", comment: "")
        lblUpdate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Update", comment: "")
        lblDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Delete", comment: "")
        lblClose.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: "")
    }
}
