//  CommentHeaderView.swift
//  Dawadawa
//  Created by ESEARCH05 on 29/11/22.

import UIKit

class CommentHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var buttonShowSetails:UIButton!
    var callBack:((String)->())?
    
    @IBAction func buttonTappedShowDetail(_ sender:UIButton){
        self.callBack?("detail")
    }
}
