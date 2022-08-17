//
//  PremiumTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PremiumTableViewCell: UITableViewCell {
    var callbacknavigation:((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        self.callbacknavigation?("Filter")
    }
    
    
}
