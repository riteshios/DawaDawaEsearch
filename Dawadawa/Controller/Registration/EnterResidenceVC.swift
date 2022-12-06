//  EnterResidenceVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/12/22.

import UIKit

class EnterResidenceVC: UIViewController {

    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var txtfieldLocality: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()

    }
    
    func setup(){
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
