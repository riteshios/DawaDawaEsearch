//
//  UploadImageCollectionViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 07/07/22.
//

import UIKit

class UploadImageCollectionViewCell: UICollectionViewCell {
    var callback:(()->())?
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?()
    }
    
}
