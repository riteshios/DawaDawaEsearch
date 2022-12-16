//  DocumentCollectionViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/09/22.

import UIKit

protocol DocumentCollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: DocumentCollectionViewCell?, index: Int, didTappedInTableViewCell: DetailsTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class DocumentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblDocument: UILabel!
    var callback:((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func btnDocumentTapped(_ sender: UIButton) {
//        self.callback?()
    }
    
    
}
