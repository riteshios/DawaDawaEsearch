//
//  PlanListTableViewCell.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 02/08/22.


import UIKit

class PlanListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var lblPlan: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
