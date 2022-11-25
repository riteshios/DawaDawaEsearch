//  SubCommentTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 25/08/22.

import UIKit

class SubCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSubCommentUser: UIImageView!
    @IBOutlet weak var lblSubComment: UILabel!
    
    var callback:((String)->())?
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btniconSubCommentTapped(_ sender: UIButton){
      
        self.callback?("IconSubComment")
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

