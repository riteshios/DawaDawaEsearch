//
//  MoreVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit

class MoreVC: UIViewController {
    
    @IBOutlet weak var ViewMain: UIView!
    //    var callback4:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewMain.clipsToBounds = true
        ViewMain.layer.cornerRadius = 25
        ViewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        ViewMain.addShadowWithBlurOnView(ViewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)

    }
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

  

}
