//  NumberChangedSuccessfulPopUpVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 27/06/22.


import UIKit
import SwiftyGif
class NumberChangedSuccessfulPopUpVC: UIViewController {

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var lblNumberChanged: UILabel!
    @IBOutlet weak var lblYourMobile: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    var callbackpopup:(()->())?
    
//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setUI()
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callbackpopup?()
    }
    
    func setUI(){
        self.animationView.backgroundColor = .clear
        do {
            let gif = try UIImage(gifName: "success.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage:gif, loopCount: 1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFill
                imageview.frame = self.animationView.bounds
                self.animationView.addSubview(imageview)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Localization
extension NumberChangedSuccessfulPopUpVC{
    func setuplanguage(){
        lblNumberChanged.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Number changed successfully", comment: "")
        lblYourMobile.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Your mobile number changed successfully", comment: "")
        btnClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: ""), for: .normal)
    }
   
}
