//
//  PaymentVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 12/09/22.

import UIKit
import Stripe
import SwiftyJSON
import Alamofire

class PaymentVC: UIViewController {
    
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var viewPay: UIView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var txtfieldcardNumber: STPPaymentCardTextField!
    var paymentIntentClientSecret = ""
    var price = ""
    
    
    var indexcount = 0
    var subsdata = [Subscription_data]()
    var payment_terms = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.getPlanApi()
        self.getSecretKey()
        self.viewPay.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        StripeAPI.defaultPublishableKey = "pk_test_51LUU9lSEPPSFgjen2ZegQAsLCVxgSmxxIs6AXPH8bo2kUidir4DuZomtqfyZRbce9AsbJzmNaicXAuMZZRKMbn5Q00vLc7e5Mv"
    }
    
    func getPlanApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        self.getSubcriptionPlan { plan in
            CommonUtils.showHudWithNoInteraction(show: false)
            self.subsdata = plan
            
        }
    }
    
    //    APi call
    func getSecretKey(){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let amount = Double(price)
        let currency = "USD"
        debugPrint("price0000",amount)
        self.getAuthSecretKey(amount:amount ?? 0.0, currency: currency) { receivedData in
            CommonUtils.showHudWithNoInteraction(show: false)
            self.paymentIntentClientSecret = receivedData
            print("Secretkey-------",self.paymentIntentClientSecret)
        }
    }
    //    MARK: - @IBAction
    
    @IBAction func btndismiss(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonTappedPa(_ sender:UIButton){
        
        //        let paymentIntentClientSecret = paymentIntentClientSecret
        
        //        else {
        
        //                    return;
        
        //                }
        
        let cardParams = txtfieldcardNumber.cardParams
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        
        
        // Submit the payment
        
        let paymentHandler = STPPaymentHandler.shared()
        
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            
            switch (status) {
                
            case .failed:
                
                print("Payment failed")
                
                print(error)
                
                break
                
            case .canceled:
                
                print("Payment canceled")
                
                break
                
            case .succeeded:
                
                print("Payment succeeded")
                debugPrint(paymentIntent?.amount)
                debugPrint(paymentIntent?.description)
                debugPrint(paymentIntent?.paymentMethodId)
                
                self.storepaymentapi(message: paymentIntent!)
                
                break
                
            @unknown default:
                
                fatalError()
                
                break
                
            }
            
        }
    }
    
}


extension PaymentVC: STPAuthenticationContext{
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension PaymentVC{
    
    //     Api call
    
    func getAuthSecretKey(amount: Double,currency:String ,outputBlock:@escaping (_ receivedData: String) ->Void){
        
        let speciDict = [
            "currency": "USD",
            "items": [
                
                "amount": amount
            ]
            
        ] as [String : Any]
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Authorization": kSharedUserDefaults.getLoggedInAccessToken()
        ]
        debugPrint("accessToken=-=-=",headers)
        
        let url = "\(kBASEURL)api/stripeSeceret"
        
        debugPrint(url)
        
        Alamofire.request(url, method: .post, parameters: speciDict, encoding:  JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if response.response != nil {
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(" team List json is:\n\(json)")
                    
                    let parser = SecretKeyParser(json)
                    outputBlock(parser.clientSecret)
                    
                }else {
                    outputBlock("Fail")
                }
                
            }else {
                outputBlock("Fail")
            }
        }
    }
    
    //    Store Payment Api
    
    func storepaymentapi(message:STPPaymentIntent){
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        let params:[String : Any] = [
            "user_id":Int.getInt(UserData.shared.id),
            "clientSecret":self.paymentIntentClientSecret,
            "amount":message.amount,
            "confirmationMethod":"Automatic",
            "currency":"USD",
            "transaction_id":message.paymentMethodId ?? "",
            "isLiveMode":"false",
            "postalCode":txtfieldcardNumber.postalCode ?? "12345",
            "brand":"visa",
            "country":txtfieldcardNumber.countryCode ?? "India",
            "expiryMonth":txtfieldcardNumber.expirationMonth,
            "expiryYear":txtfieldcardNumber.expirationYear,
            "funding":"funding",
            "paymentMethodId":message.paymentMethodId,
            "paymentMethodTypes":"card",
            "status":"succeeded",
            "created":"2022-09-16",// Thread
            "canceledAt":message.canceledAt ?? 0,
            "package_id":self.subsdata[self.indexcount].id,
            "payment_terms":self.payment_terms
        ]
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kstorepayment, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["responsecodes"]) == 200{
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        let payments_id = String.getString(dictResult["payments_id"])
                        print("payments_idRitesh",payments_id)
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        kSharedAppDelegate?.makeRootViewController()
                    }
                    
                    else if  Int.getInt(dictResult["responsecodes"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
}

// MARK: - Localisation

extension PaymentVC{
    
    func setuplanguage(){
        lblPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pay", comment: "")
        btnPay.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pay", comment: ""), for: .normal)
    }
}


