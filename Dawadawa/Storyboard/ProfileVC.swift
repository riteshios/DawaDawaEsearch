//
//  ProfileVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/06/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var ImageProfile: UIImageView!
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var isProfileImageSelected = false
    var email:String?
    var userImage:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblFullName.text = String.getString(UserData.shared.name) + " " + String.getString(UserData.shared.last_name)
        self.lblMobileNumber.text = UserData.shared.phone
        self.lblEmail.text = UserData.shared.email
    }
    
// MARK: - @IBAction
    
    @IBAction func btnEditImage(_ sender: UIButton) {
        ImagePickerHelper.shared.showPickerController { image, url in
            self.isProfileImageSelected = true
            self.ImageProfile.image = image
            self.uploadImage(image: self.ImageProfile.image ?? UIImage())
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
            if txt == "EditProfile"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(identifier: EditProfileVC.getStoryboardID()) as! EditProfileVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if txt == "ChangePassword"{
                self.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordOTPVerifyVC.getStoryboardID()) as! ChangePasswordOTPVerifyVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callbackotp = {
                        self.dismiss(animated: false){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordVC.getStoryboardID()) as! ChangePasswordVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.callbackchangepassword = {
                                self.dismiss(animated: false){
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: PasswordChangedSuccessfullyPopUpVC.getStoryboardID()) as! PasswordChangedSuccessfullyPopUpVC
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .overCurrentContext
                                    vc.callbackpopuop = {
                                        self.dismiss(animated: false){
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier:ProfileVC.getStoryboardID()) as! ProfileVC
                                            self.navigationController?.pushViewController(vc, animated: false)
                                        }
                                        
                                    }
                                    self.present(vc, animated: false)
                                }
                            }
                            self.present(vc, animated: false)
                        }
                        
                    }
                    self.present(vc, animated: false)
                }
            }
            if txt == "Logout"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: LogOutVC.getStoryboardID()) as! LogOutVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.callbacklogout = { txt in
                        if txt == "Cancel"{
                            vc.dismiss(animated: false){
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: ProfileVC.getStoryboardID()) as! ProfileVC
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
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
// MARK: -API call

extension ProfileVC{
    
    func uploadImage(image:UIImage?){
        CommonUtils.showHud(show: true)
        
        let params:[String : Any] = [
            "user_id":UserData.shared.id
        ]

        let uploadimage:[String:Any] =
        ["profile_image": self.ImageProfile.image ?? UIImage()
        ]
                
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName:ServiceName.keditprofileimage , requestMethod: .post, requestImages: [uploadimage], requestVideos: [:], requestData:params)
        { (result:Any?, error:Error?, errortype:ErrorType?, statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errortype == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let data =  kSharedInstance.getDictionary(dictResult["data"])
                        let obj = kSharedInstance.getDictionary(data["social_profile"])
                        self.userImage = String.getString(obj.first)
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                   
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errortype == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
}
