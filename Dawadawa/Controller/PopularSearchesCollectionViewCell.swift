//
//  PopularSearchesCollectionViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PopularSearchesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPopularSearch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = CGColor(red: 21, green: 114, blue: 161, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = lblPopularSearch.frame.size.height / 2.0
        self.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
        self.lblPopularSearch.textColor = UIColor(red: 21, green: 114, blue: 161)
    }

}
