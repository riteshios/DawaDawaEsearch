//  BuyPlanVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 13/09/22.

import UIKit
import SwiftUI

class BuyPlanVC: UIViewController {
    
//    MARK: - Properties
    
    @IBOutlet weak var PlanCollectionView: UICollectionView!
    @IBOutlet weak var lblUsertype: UILabel!
    @IBOutlet weak var btnChoosethisPlan: UIButton!
    
    var indexpathcount = 0
    var subsdata = [Subscription_data]()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.getPlanApi()
        self.fetdata()
    }
    
    func fetdata(){
        PlanCollectionView.register(UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PlanCollectionViewCell")
        
        if UserData.shared.user_type == "0"{
            self.lblUsertype.text = "Investor"
            lblUsertype.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Investor", comment: "")
        }
        else if UserData.shared.user_type == "1"{
            self.lblUsertype.text = "Business Owner"
            lblUsertype.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Business Owner", comment: "")
        }
        else if UserData.shared.user_type == "2"{
            self.lblUsertype.text = "Service Provider"
            lblUsertype.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Service Provider", comment: "")
        }
    }
    
    func getPlanApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        self.getSubcriptionPlan { plan in
            CommonUtils.showHudWithNoInteraction(show: false)
            self.subsdata = plan
            DispatchQueue.main.async {
                self.PlanCollectionView.reloadData()
            }
        }
    }
    
//    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChoosePlanTapped(_ sender: UIButton){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: ChoosePlanVC.getStoryboardID()) as! ChoosePlanVC
//        vc.indexcount = self.indexpathcount
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: PaymentVC.getStoryboardID()) as! PaymentVC
        vc.price = String.getString(self.subsdata[self.indexpathcount].price_month)
        vc.indexcount = self.indexpathcount
        vc.payment_terms = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Collection

extension BuyPlanVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subsdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PlanCollectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        cell.subsdata = self.subsdata[indexPath.row]
        let imgUrl = URL(string: self.subsdata[indexPath.row].image)
        cell.imgBG.sd_setImage(with: imgUrl)
        cell.descData = self.subsdata[indexPath.item].description
        cell.cellnumbercount(num: indexPath.row)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // Counting the scroll of collection view
        for cell in PlanCollectionView.visibleCells {
            let indexPath = PlanCollectionView.indexPath(for: cell)
            debugPrint("indexPath=-=-",indexPath)
            self.indexpathcount = indexPath?[1] ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PlanCollectionView.frame.size.width, height:  PlanCollectionView.frame.size.height)
    }
    
}

extension BuyPlanVC{
    
    func setuplanguage(){
        btnChoosethisPlan.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Choose this plan", comment: ""), for: .normal)
    }
}
