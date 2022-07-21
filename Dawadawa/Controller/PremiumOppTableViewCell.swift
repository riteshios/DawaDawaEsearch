//
//  PremiumOppTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PremiumOppTableViewCell: UITableViewCell {

    @IBOutlet weak var ColllectionViewPremiumOpp: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ColllectionViewPremiumOpp.delegate = self
        ColllectionViewPremiumOpp.dataSource = self
        ColllectionViewPremiumOpp.register(UINib(nibName: "PremiumOppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PremiumOppCollectionViewCell")
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
extension PremiumOppTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ColllectionViewPremiumOpp.dequeueReusableCell(withReuseIdentifier: "PremiumOppCollectionViewCell", for: indexPath) as! PremiumOppCollectionViewCell
        return cell
    }
   

  
}
