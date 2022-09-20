//
//  PlanTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 02/08/22.


import UIKit

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPlan: UILabel!
    
    @IBOutlet weak var lblPricePerMonth: UILabel!
    @IBOutlet weak var lblCutPricePerYear: UILabel!
    @IBOutlet weak var lblPricePerYear: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
