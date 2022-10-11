//
//  ChoosePlanVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 12/09/22.
//

import UIKit

class ChoosePlanVC: UIViewController {
    
    @IBOutlet weak var viewMonthlyPlan: UIView!
    @IBOutlet weak var viewYearlyPlan: UIView!
    
    @IBOutlet weak var lblPlanMonthly: UILabel!
    @IBOutlet weak var lblPriceMonthly: UILabel!
    @IBOutlet weak var lblPlanYearly: UILabel!
    @IBOutlet weak var lblPriceYearly: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    var subsdata = [Subscription_data]()
    
    var indexcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPlanApi()
        viewMonthlyPlan.addShadowWithBlurOnView(viewMonthlyPlan, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        
        viewYearlyPlan.addShadowWithBlurOnView(viewYearlyPlan, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
        
    }
    
    func getPlanApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        self.getSubcriptionPlan { plan in
            CommonUtils.showHudWithNoInteraction(show: false)
            self.subsdata = plan
            
            
            if UserData.shared.user_type == "0"{
                self.lblPlanMonthly.text  = self.subsdata[self.indexcount].title
                self.lblPlanYearly.text   = self.subsdata[self.indexcount].title
                self.lblPriceMonthly.text = self.subsdata[self.indexcount].price_month
                print("lblPriceMonthly",self.subsdata[self.indexcount].price_month)
                self.lblPriceYearly.text  = self.subsdata[self.indexcount].price_year
            }
            else if UserData.shared.user_type == "1"{
                self.viewYearlyPlan.isHidden = true
                self.lblMonth.isHidden = true
                self.lblPlanMonthly.text  = self.subsdata[self.indexcount].title
                self.lblPriceMonthly.text = "$\(String.getString(self.subsdata[self.indexcount].price_month))"
                
            }
            else if UserData.shared.user_type == "2"{
                self.viewYearlyPlan.isHidden = true
                self.lblMonth.isHidden = true
                self.lblPlanMonthly.text  = self.subsdata[self.indexcount].title
                self.lblPriceMonthly.text = "$\(String.getString(self.subsdata[self.indexcount].price_month))"
            }
        }
    }
    //    MARK: - @IBAction
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChoosemonthlyPlan(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: PaymentVC.getStoryboardID()) as! PaymentVC
        vc.price = String.getString(self.subsdata[self.indexcount].price_month)
        vc.indexcount = self.indexcount
        vc.payment_terms = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChooseYearlyPlan(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: PaymentVC.getStoryboardID()) as! PaymentVC
        vc.price = String.getString(self.subsdata[self.indexcount].price_year)
        vc.indexcount = self.indexcount
        vc.payment_terms = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

