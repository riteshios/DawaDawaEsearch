//
//  ProfileVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var ImageProfile: UIImageView!
    
    var isProfileImageSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnEditImage(_ sender: UIButton) {
        ImagePickerHelper.shared.showPickerController { image, url in
            self.ImageProfile.image = image
            self.isProfileImageSelected = true
        }
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: MoreVC.getStoryboardID()) as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback4 = { txt in
            if txt == "Dismiss"{
                vc.dismiss(animated: false){
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            if txt == "Setting"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(identifier: SettingVC.getStoryboardID()) as! SettingVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if txt == "Logout"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: LogOutVC.getStoryboardID()) as! LogOutVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callbacklogout = { txt in
                        if txt == "Cancel"{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                        
                        if txt == "Logout"{
                            vc.dismiss(animated: false) {
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                    }
                    self.present(vc, animated: false)
                }
            }
          
        }
        self.present(vc, animated: false)
    }
}
