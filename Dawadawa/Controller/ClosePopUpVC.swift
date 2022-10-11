//
//  ClosePopUpVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 22/07/22.
//

import UIKit

class ClosePopUpVC: UIViewController {
    
    var callback:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callback?("Close")
    }
}
