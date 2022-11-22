//  ChangeNumberVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 27/06/22.

import UIKit
import SKFloatingTextField

class ChangeNumberVC: UIViewController {
    
    @IBOutlet weak var viewSendCode: UIView!
    @IBOutlet weak var viewMain: UIView!
    var callbackchangenumber:(()->())?
    @IBOutlet weak var txtFieldNumber: SKFloatingTextField!
    
//     MARK: - Life Cycle
    
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

extension ChangeNumberVC{
    
}
