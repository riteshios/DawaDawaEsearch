//
//  ChangeNumberVC.swift
//  Dawadawa
//
//  Created by Alekh on 27/06/22.
//

import UIKit
import SKFloatingTextField

class ChangeNumberVC: UIViewController {
    var callbackchangenumber:(()->())?

    @IBOutlet weak var txtFieldNumber: SKFloatingTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnSendCodeTapped(_ sender: UIButton) {
        self.callbackchangenumber?()
    }
    

}
