//
//  BuyPlanVC.swift
//  Dawadawa
//
//  Created by Alekh on 13/09/22.
//

import UIKit
import SwiftUI

class BuyPlanVC: UIViewController {
    
//    MARK: - Properties
    
    @IBOutlet weak var PlanCollectionView: UICollectionView!
    @IBOutlet weak var lblUsertype: UILabel!
    
    var indexpathcount = 0
    var subsdata = [Subscription_data]()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPlanApi()
        self.fetdata()
    }
    
    func fetdata(){
        PlanCollectionView.register(UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PlanCollectionViewCell")
        
        if UserData.shared.user_type == "0"{
            self.lblUsertype.text = "Investor"
        }
        else if UserData.shared.user_type == "1"{
            self.lblUsertype.text = "Business Owner"
        }
        else if UserData.shared.user_type == "2"{
            self.lblUsertype.text = "Service Provider"
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ChoosePlanVC.getStoryboardID()) as! ChoosePlanVC
        vc.indexcount = self.indexpathcount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Collection

extension BuyPlanVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subsdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PlanCollectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        cell.subsdata = self.subsdata
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
}
