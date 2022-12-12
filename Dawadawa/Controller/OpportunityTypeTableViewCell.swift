//  OpportunityTypeTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/07/22.

import UIKit

class OpportunityTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnSelectOpptype: UIButton!
    @IBOutlet weak var imgradio: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    var callback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnSelectopptypetapped(_ sender: UIButton) {
        self.callback?()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
