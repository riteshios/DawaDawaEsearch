//
//  QuitVCViewController.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/07/22.
//

import UIKit

class QuitVCViewController: UIViewController {
    
    var callbackquit:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnQuitTapped(_ sender: UIButton) {
        self.callbackquit?("Quit")
    }
    
  

}
