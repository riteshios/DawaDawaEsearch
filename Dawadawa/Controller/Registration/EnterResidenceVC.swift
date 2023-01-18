//  EnterResidenceVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 02/12/22.

import UIKit

class EnterResidenceVC: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var txtfieldLocality: UITextField!
    @IBOutlet weak var labelCountry:UILabel!
    @IBOutlet weak var labelState:UILabel!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    var name = ""
    var lastame = ""
    var usertype = 0
    var email = ""
    var phone = ""
    
    var country = [Country]()
    var state = [StateData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setuplanguage()
        self.getCountryStateApi()
    }
    
    func setup(){
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
    }
    
    //    MARK: - @IBAction
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonTappedCountry(_ sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryStatePopUpVC") as! CountryStatePopUpVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.data.removeAll()
        for i in 0 ..< country.count - 1{
            vc.data.append(String.getString(self.country[i].name))
        }
        vc.callback = { txt in
            vc.dismiss(animated: true){
                self.labelCountry.text = String.getString(txt)
            }
        }
        self.present(vc, animated: true)
    }
    
    
    @IBAction func buttonTappedState(_ sender:UIButton){
        if self.labelCountry.text == "Country"{
            self.showSimpleAlert(message: "Please Select Country")
            return
        }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryStatePopUpVC") as! CountryStatePopUpVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.lbldata = "State name"
            vc.data.removeAll()
            for i in 0 ..< country.count - 1{
                if self.labelCountry.text == self.country[i].name{
                    if self.country[i].state.count > 0{
                        for j in 0 ..< self.country[i].state.count - 1{
                            vc.data.append(String.getString(country[i].state[j].name))
                        }
                    }
                    break
                }
            }
            
            vc.callback = { txt in
                vc.dismiss(animated: true){
                    self.labelState.text = String.getString(txt)
                }
            }
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        self.validation()
        
    }
    
    //    MARK: - Validation()
    
    func validation(){
        
        if self.labelCountry.text == "Country"{
            self.showSimpleAlert(message: "Please Select Country")
            return
        }
        else if self.labelState.text == "State"{
            self.showSimpleAlert(message: "Please Select State")
            return
        }
        else if String.getString(self.txtfieldLocality.text).isEmpty{
            self.showSimpleAlert(message: "Please Enter Locality")
        }
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordVC
        vc.name = self.name
        vc.lastame = self.lastame
        vc.usertype = self.usertype
        vc.email = self.email
        vc.phone = self.phone
        vc.country = self.labelCountry.text ?? ""
        vc.state = self.labelState.text ?? ""
        vc.locality = self.txtfieldLocality.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EnterResidenceVC{
    
    func getCountryStateApi(){
        let url = "https://countriesnow.space/api/v0.1/countries/states"
        CommonUtils.showHudWithNoInteraction(show: true)
        TANetworkManager.sharedInstance.requestApi(withServiceName: url, requestMethod: .GET, requestParameters: [:], withProgressHUD: false) {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getArray(withDictionary: dictResult["data"])
                    self?.country = data.map{Country(data: kSharedInstance.getDictionary($0))}
                    
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["msg"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
//                CommonUtils.showToastForDefaultError()
            }
        }
    }
}
// MARK: - Localisation

extension EnterResidenceVC{
    func setuplanguage(){
        lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Let's get started with country of residence", comment: "")
        lblSubHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please choose your country of residence from the options below", comment: "")
        labelCountry.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Country", comment: "")
        labelState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "State", comment: "")
        txtfieldLocality.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Locality", comment: "")
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Continue", comment: ""), for: .normal)
    }
}
