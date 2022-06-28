//
//  ChangeEmailVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/06/22.
//

import UIKit
import SKFloatingTextField

class ChangeEmailVC: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: SKFloatingTextField!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSendCode: UIView!
    var callbackchangenumber:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewSendCode.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    @IBAction func btnSendCodeTapped(_ sender: UIButton) {
        self.callbackchangenumber?()
    }
    

}
