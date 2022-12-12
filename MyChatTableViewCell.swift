//
//  MyChatTableViewCell.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 01/11/22.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblcountmessage:UILabel!
    @IBOutlet weak var viewCountMessage:UIView!
    
    var callback:((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btnChatTapped(_ sender: UIButton) {
        self.callback?("Chat")
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.callback?("Delete")
    }
    
}
