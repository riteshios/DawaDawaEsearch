//
//  SocialPostTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class SocialPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    var callbackmore:(()->())?
 
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var Imageuser: UIImageView!
    
    var img = [oppr_image](){
        didSet{
            self.SocialPostCollectionView.reloadData()
        }
    }
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
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callbackmore?()
    }
    
    
}
extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        
        return cell
    }
}
