//
//  InvestorSubscriptionVC.swift
//  Dawadawa
//
//  Created by Alekh on 02/08/22.
//

import UIKit

class InvestorSubscriptionVC: UIViewController {
    
    @IBOutlet weak var PlanCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlanCollectionView.register(UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PlanCollectionViewCell")
     
    }
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   

}
extension InvestorSubscriptionVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PlanCollectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//        {
//           return CGSize(width: 375, height: 623)
//        }
    
}
