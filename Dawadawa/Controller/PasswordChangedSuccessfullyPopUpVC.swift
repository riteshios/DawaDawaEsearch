//  PasswordChangedSuccessfullyPopUpVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/06/22.

import UIKit
import SwiftyGif

class PasswordChangedSuccessfullyPopUpVC: UIViewController {

    @IBOutlet weak var lblPasswordChange: UILabel!
    @IBOutlet weak var lblYourPassword: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var animationView: UIView!
    
    var callbackpopuop:(()->())?
    
//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
//    MARK: - @IBAction
    
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callbackpopuop?()
    }
    
    func setUI(){
        self.animationView.backgroundColor = .clear
        do {
            let gif = try UIImage(gifName: "success.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage:gif, loopCount: 1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFill
                imageview.frame = self.animationView.bounds
                self.animationView.addSubview(imageview)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Localisation

extension PasswordChangedSuccessfullyPopUpVC{
    func setuplanguage(){
        lblPasswordChange.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Password changed successfully", comment: "")
        lblYourPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Your password changed successfully, now you can loggin to your account", comment: "")
        btnClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: ""), for: .normal)
    }
}
