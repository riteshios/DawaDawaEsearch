//
//  NotificationTableViewCell.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 10/10/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var imglogo: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    var callback:((String,UIButton) ->())?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btnSelectNotificationDetail(_ sender: UIButton) {
        self.callback?("Notificationdetail",sender)
    }
    
}
