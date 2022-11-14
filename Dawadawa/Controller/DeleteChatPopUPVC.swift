//
//  DeleteChatPopUPVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 11/11/22.
//

import UIKit

class DeleteChatPopUPVC: UIViewController {
    
    var callback:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.callback?("Dismiss")
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("DeleteChat")
        
    }
    
}
