//  EmailChangedSuccessfullyPopUpVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/06/22.

import UIKit
import SwiftyGif

class EmailChangedSuccessfullyPopUpVC: UIViewController {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var lblEmailChaged: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    
    
    var callbackpopup:(()->())?
    var email:String?
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.setUI()
        
    }
    
    //    MARK: - @IBAction
    
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
extension EmailChangedSuccessfullyPopUpVC{
    func setuplanguage(){
        lblEmailChaged.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email changed successfully", comment: "")
        lblSubheading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Your email address changed successfully", comment: "")
        btnClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Close", comment: ""), for: .normal)
    }
}
