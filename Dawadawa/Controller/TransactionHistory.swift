//
//  TransactionHistory.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 16/09/22.
//

import UIKit

class TransactionHistory: UITableViewCell {

    @IBOutlet weak var lblTransactionid: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var viewSuccessful: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        viewSuccessful.clipsToBounds = true
//        viewSuccessful.layer.cornerRadius = 8
//        viewSuccessful.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
