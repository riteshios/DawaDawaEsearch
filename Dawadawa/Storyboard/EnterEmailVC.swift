//  EnterEmailVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/12/22.


import UIKit
import SKFloatingTextField

class EnterEmailVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtfldEmail: SKFloatingTextField!
    @IBOutlet weak var viewContinue: UIView!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.lblName.text = self.name
    }
    
    func setup(){
        self.viewContinue.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtfldEmail, place: "Email*", floatingText: "Email")
    }
    
//     MARK: - @IBACtion
    
    @IBAction func btnbackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPhoneNumberVC") as! EnterPhoneNumberVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension EnterEmailVC{
    func setTextFieldUI(textField:SKFloatingTextField,place:String ,floatingText:String){
        
        textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        //floatingTextField.setRectTFUI()
        //floatingTextField.setRoundTFUI()
        //floatingTextField.setOnlyBottomBorderTFUI()
        //        textField.setCircularTFUI()
        textField.setRoundTFUI()
        textField.delegate = self
        //floatingTextField.errorLabelText = "Error"
        
    }
}
extension EnterEmailVC : SKFlaotingTextFieldDelegate {
    
    func textFieldDidEndEditing(textField: SKFloatingTextField) {
        print("end editing")
    }
    
    func textFieldDidChangeSelection(textField: SKFloatingTextField) {
        print("changing text")
    }
    
    func textFieldDidBeginEditing(textField: SKFloatingTextField) {
        print("begin editing")
    }
}