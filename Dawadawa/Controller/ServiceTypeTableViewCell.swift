//  ServiceTypeTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/07/22.

import UIKit

class ServiceTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblServicetype: UILabel!
    @IBOutlet weak var imgradio: UIImageView!
    @IBOutlet weak var btnSelection: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
