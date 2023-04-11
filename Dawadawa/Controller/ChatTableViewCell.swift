//  ChatTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 01/11/22.


import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ViewReciver: UIView!
    @IBOutlet weak var lblNameReceiver: UILabel!
    @IBOutlet weak var lblStatusReceiver: UILabel!
    @IBOutlet weak var lblMessageReceiver: UILabel!
    @IBOutlet weak var heightViewReceiver: NSLayoutConstraint!
    
    @IBOutlet weak var ViewSender: UIView!
    @IBOutlet weak var lblNameSender: UILabel!
    @IBOutlet weak var lblStatusSender: UILabel!
    @IBOutlet weak var lblMessageSender: UILabel!
    @IBOutlet weak var heightViewSender: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUser(user:Int!, message:String!,date:String!){
      
        if UserData.shared.id == user
        {
            lblMessageSender .text = message
            lblStatusSender.text = date
            lblNameSender.text = "You"
            ViewReciver.isHidden = true
            ViewSender.isHidden = false
//          heightCustomerView.constant = 0
            
        }else{
            lblStatusReceiver.text = date
//          lblNameReceiver.text = user
            lblMessageReceiver.text = message
            ViewReciver.isHidden = false
            ViewSender.isHidden = true
//          heightUserView.constant = 0
          
        }
    }
}
