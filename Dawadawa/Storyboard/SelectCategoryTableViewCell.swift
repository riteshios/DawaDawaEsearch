//
//  SelectCategoryTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 08/07/22.
//

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var SelectCategoryLabel: UILabel!
    @IBOutlet weak var SelectCategoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
