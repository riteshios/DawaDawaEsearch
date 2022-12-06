//  QuitVCViewController.swift
//  Dawadawa
//  Created by Ritesh Gupta on 11/07/22.

import UIKit

class QuitVCViewController: UIViewController {
    
    @IBOutlet weak var lblquit: UILabel!
    @IBOutlet weak var lblsecondHeading: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var lblQuit: UILabel!
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewQuit: UIView!
    
    var callbackquit:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
//        viewCancel.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        viewQuit.addShadowWithBlurOnView(viewQuit, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        viewCancel.layer.shadowColor = UIColor.gray.cgColor
        viewCancel.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewCancel.layer.shadowOpacity = 0.3
        viewCancel.layer.shadowRadius = 2.0
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnQuitTapped(_ sender: UIButton) {
        self.callbackquit?("Quit")
    }
}
// MARK: - Localisation

extension QuitVCViewController{
    func setuplanguage(){
        lblquit.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Quit", comment: "")
        lblsecondHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Do you really want to quit now?", comment: "")
        lblCancel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: "")
        lblQuit.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Quit", comment: "")
    }
}
