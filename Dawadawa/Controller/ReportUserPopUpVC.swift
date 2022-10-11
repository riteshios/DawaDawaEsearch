//
//  ReportUserPopUpVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/10/22.


import UIKit

class ReportUserPopUpVC: UIViewController {
    
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
    
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
