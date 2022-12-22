//  HomeSocialMoreSelfVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 30/08/22.
//

import UIKit

class HomeSocialMoreSelfVC: UIViewController {
    
    var callback:((String)->())?
    @IBOutlet weak var Viewmain: UIView!
    @IBOutlet weak var viewBG:UIView!
    @IBOutlet weak var lblupdate: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var lblCopylink: UILabel!
    @IBOutlet weak var lblViewDetails: UILabel!
    
    
//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setup()
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
    
    //    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        //  self.callback?("Dismiss")
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUpdateTapped(_ sender: UIButton) {
        self.callback?("Update")
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callback?("Close")
    }
    
    @IBAction func btnCopyLinkTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnvViewDetailsTapped(_ sender: UIButton) {
        self.callback?("viewdetails")
        self.dismiss(animated: true)
    }
}

// MARK: - Localisation

extension HomeSocialMoreSelfVC{
    func setuplanguage(){
        lblupdate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Update", comment: "")
        lblClose.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: "")
        lblCopylink.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Copy Link", comment: "")
        lblViewDetails.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "View Details", comment: "")
    }
}
