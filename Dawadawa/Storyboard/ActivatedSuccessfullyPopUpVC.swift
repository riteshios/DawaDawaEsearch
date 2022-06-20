//
//  ActivatedSuccessfullyPopUpVC.swift
//  Dawadawa
//
//  Created by Alekh Verma on 10/06/22.
//

import UIKit
import SwiftyGif


class ActivatedSuccessfullyPopUpVC: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var animationView: UIView!
    
    var type:HasCameFrom?
    
    var isSignup = false
    var isReset = false
    var callback1:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .signUp{
            self.lblHeading.text = "Account activated successfully"
            self.lblSubHeading.text = "Your account activated successfully, now you can explore all the exclusive opportunities"
            self.btnContinue.setTitle("Continue", for: .normal)
        }
        else if type == .reset{
            self.lblHeading.text = "Password reset successfully"
            self.lblSubHeading.text = "Successfully reset your password, now you can login to your account"
            self.btnContinue.setTitle("Close", for: .normal)
            self.btnContinue.setTitleColor(UIColor(hexString: "#A6A6A6"), for: .normal)
        }
        self.setUI()
        //        self.setupgif()
    }
    
    //    func setupgif(){
    //
    //        self.animationView.contentMode = .scaleAspectFit
    //        self.animationView.loopMode = .loop
    //        self.animationView.animationSpeed = 0.5
    //        self.animationView.play()
    //       }
    func setUI(){
        self.animationView.backgroundColor = .clear
        do {
            let gif = try UIImage(gifName: "success.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage:gif, loopCount: -1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFill
                imageview.frame = self.animationView.bounds
                self.animationView.addSubview(imageview)
            }
        } catch {
            print(error)
        }
    }
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        
        self.callback1?()
        
    }
    
}
