//
//  NumberChangedSuccessfulPopUpVC.swift
//  Dawadawa
//
//  Created by Alekh on 27/06/22.
//

import UIKit
import SwiftyGif
class NumberChangedSuccessfulPopUpVC: UIViewController {

    @IBOutlet weak var animationView: UIView!
    var callbackpopup:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
