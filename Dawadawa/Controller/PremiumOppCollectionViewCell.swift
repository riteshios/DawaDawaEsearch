//
//  PremiumOppCollectionViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class PremiumOppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPremium: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var viewImage: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // border
        viewImage.layer.borderWidth = 1.0
        viewImage.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        viewImage.layer.shadowColor = UIColor.black.cgColor
        viewImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewImage.layer.shadowOpacity = 0.7
        viewImage.layer.shadowRadius = 4.0

      
    }

}
