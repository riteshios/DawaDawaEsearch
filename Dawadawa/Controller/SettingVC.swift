//
//  SettingVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/06/22.
//

import UIKit


class SettingVC: UIViewController {

    @IBOutlet weak var lblDropDownMenu: UILabel!
    @IBOutlet weak var imgDropDownMenu: UIImageView!
    @IBOutlet weak var btndrop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnDropTapped(_ sender: UIButton) {
        let dataSource1 = ["English-IND","Arabic","Japanese"]
        let dataimg = UIImage(named: "Frame 162")
        kSharedAppDelegate?.dropDown(dataSource:dataSource1,img: dataimg, text: btndrop)
        {(Index ,item) in
            self.lblDropDownMenu.text = item
            self.imgDropDownMenu.image = item
    }
}
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
