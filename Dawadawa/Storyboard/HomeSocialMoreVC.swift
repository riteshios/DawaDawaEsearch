//
//  HomeSocialMoreVC.swift
//  Dawadawa
//  Developer: - Ritesh Gupta
//  Created by Alekh on 22/07/22.
//

import UIKit

class HomeSocialMoreVC: UIViewController {
    
    var callback:((String)->())?

    @IBOutlet weak var Viewmain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
       
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
    
 
    
}
