//
//  SocialPostTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class SocialPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.awakeFromNib()
        SocialPostCollectionView.delegate = self
        SocialPostCollectionView.dataSource = self
        SocialPostCollectionView.register(UINib(nibName: "SocialPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialPostCollectionViewCell")
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        return cell
    }
}
