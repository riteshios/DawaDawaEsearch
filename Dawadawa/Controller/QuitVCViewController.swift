//
//  QuitVCViewController.swift
//  Dawadawa
//
//  Created by Alekh on 11/07/22.
//

import UIKit

class QuitVCViewController: UIViewController {
    
    var callbackquit:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.callbackquit?("Cancel")
        
    }
    
    @IBAction func btnQuitTapped(_ sender: UIButton) {
        self.callbackquit?("Quit")
    }
    
  

}
