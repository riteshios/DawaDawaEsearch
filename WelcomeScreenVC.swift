//  WelcomeScreenVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.


import UIKit

class WelcomeScreenVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRegister: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()

        // Do any additional setup after loading the view.
    }
    
//     MARK: - Life Cycle
    func setup(){
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 25
        viewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewMain.addShadowWithBlurOnView(viewMain, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        self.viewLogin.backgroundColor = UIColor(hexString: "#F1F9FD")
        self.viewLogin.borderColor = UIColor(hexString: "#1572A1")
        self.viewLogin.cornerRadius = 10
        self.viewRegister.backgroundColor = UIColor(hexString: "#F1F9FD")
        self.viewRegister.borderColor = UIColor(hexString: "#1572A1")
        self.viewRegister.cornerRadius = 10
    }
    
//     MARK: - @IBAction
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
//        if sender.isSelected == true{
            self.viewLogin.backgroundColor = UIColor(hexString: "#1572A1")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
       
            self.viewRegister.backgroundColor = UIColor(hexString: "#1572A1")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
}


