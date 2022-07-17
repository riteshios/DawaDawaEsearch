//
//  UploadDocumentCollectionViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 13/07/22.
//

import UIKit


class UploadDocumentCollectionViewCell: UICollectionViewCell {
    var callbackclose:(()->())?
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imagedocument: UIImageView!
    @IBOutlet weak var lbldocument: UILabel!
    
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.callbackclose?()
    }
    
}
