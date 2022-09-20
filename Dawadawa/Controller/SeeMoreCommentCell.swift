//
//  SeeMoreCommentCell.swift
//  Dawadawa
//
//  Created by Alekh on 25/08/22.
//

import UIKit
import IQKeyboardManagerSwift

class SeeMoreCommentCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate  {
    
    //    MARK: - Properties
    
    @IBOutlet weak var topsubTableview: NSLayoutConstraint!
    @IBOutlet weak var tblviewSubComment: UITableView!
    
    @IBOutlet weak var imgCommentUser: UIImageView!
    @IBOutlet weak var lblNameandComment: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var txtviewsubComment: IQTextView!
    
    @IBOutlet weak var bottomSubtableview: NSLayoutConstraint!
    @IBOutlet weak var heightbuttonReply: NSLayoutConstraint!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var heightViewPostComment: NSLayoutConstraint!
    @IBOutlet weak var heightReply: NSLayoutConstraint!
    @IBOutlet weak var viewPostComment: UIView!
    
    var callback:((String)->())?
    var callbacktxtviewsubcomment: ((String) -> Void)?
    
    var subcomment = [sub_Comment]()
    
    
    
    
    //    MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        tblviewSubComment.register(UINib(nibName: "SubCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubCommentTableViewCell")
        self.tblviewSubComment.delegate = self
        self.tblviewSubComment.dataSource = self
        //        tblviewSubComment.estimatedRowHeight = 5
        self.txtviewsubComment.delegate = self
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.callbacktxtviewsubcomment = action
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        callbacktxtviewsubcomment?(textView.text)
    }
    
    func reloadTable(){
        tblviewSubComment.reloadData()
    }
    
    
    // MARK: - @IBACtion
    
    @IBAction func btnPostTapped(_ sender: UIButton) {
        self.callback?("Post")
    }
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.callback?("Cancel")
    }
    @IBAction func btnReplyTapped(_ sender: UIButton) {
        self.callback?("Reply")
    }
    //    MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subcomment.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblviewSubComment.dequeueReusableCell(withIdentifier: "SubCommentTableViewCell") as! SubCommentTableViewCell
        
        cell.lblSubComment.text = String.getString(self.subcomment[indexPath.row].usersubcommentdetails?.name) + "   " + String.getString(self.subcomment[indexPath.row].comments)
        print("data-------",String.getString(self.subcomment[indexPath.row].usersubcommentdetails?.name) + "   " + String.getString(self.subcomment[indexPath.row].comments))
        
        print("Its reloading")
        print("visibleLine  ---",cell.lblSubComment.numberOfVisibleLines)
        
        let imgsubcomment = String.getString(self.subcomment[indexPath.row].usersubcommentdetails?.image)
        cell.imgSubCommentUser.downlodeImage(serviceurl: imgsubcomment, placeHolder: UIImage(named: "Boss"))
        
        
        let first = String.getString(self.subcomment[indexPath.row].usersubcommentdetails?.name)
        let second = String.getString(self.subcomment[indexPath.row].comments)
        
        let attributedStringcomment: NSMutableAttributedString = NSMutableAttributedString(string: "\(first)  \(second)")
        attributedStringcomment.setColorForText(textToFind: first, withColor: UIColor.black)
        attributedStringcomment.setColorForText(textToFind: second, withColor: UIColor.gray)
        cell.lblSubComment.attributedText = attributedStringcomment
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
