//  SelectCategoryTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 08/07/22.

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var SelectCategoryLabel: UILabel!
    @IBOutlet weak var SelectCategoryImage: UIImageView!
    @IBOutlet weak var viewSelectCategory: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSelectCategory.addShadowWithBlurOnView(viewSelectCategory, spread: 0, blur: 10, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
