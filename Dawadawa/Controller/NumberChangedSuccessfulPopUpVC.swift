//
//  NumberChangedSuccessfulPopUpVC.swift
//  Dawadawa
//
//  Created by Alekh on 27/06/22.
//

import UIKit

class NumberChangedSuccessfulPopUpVC: UIViewController {

    var callbackpopup:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callbackpopup?()
    }
    
 


}
