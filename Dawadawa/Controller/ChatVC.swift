//
//  ChatVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 31/10/22.
//

import UIKit
import SlackTextViewController


class ChatVC: SLKTextViewController {
    
    let myFirstButton = UIButton()
        let topView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.bounces = false
        tableView?.indicatorStyle = .white
        
        bounces = false
        
        shakeToClearEnabled = true
        
        isKeyboardPanningEnabled = true
        
        shouldScrollToBottomAfterKeyboardShows = true
        
        isInverted = true
        
        textView.placeholder = "Enter Message"
        
        textInputbar.autoHideRightButton = true
        
        textInputbar.maxCharCount = 256
        
        textInputbar.counterStyle = .split
        
        textInputbar.counterPosition = .top
        tableView!.allowsSelection = false
        
        tableView!.estimatedRowHeight = 70
        
        tableView!.rowHeight = UITableView.automaticDimension
        
        tableView!.separatorStyle = .none
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
                    scrollToBottom()
                }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 95)
        topView.backgroundColor = .white
        topView.addShadowWithBlurOnView(topView, spread: 0, blur: 2, color: .black, opacity: 0.03, OffsetX: 0, OffsetY: 2)
        myFirstButton.setTitle("", for: .normal)
        if let image = UIImage(named: "blueArrowBack") {
            myFirstButton.setImage(image, for: .normal)
            
        }
        
        myFirstButton.setTitleColor(.blue, for: .normal)
        
        myFirstButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        myFirstButton.frame = CGRect(x: 5, y:32, width: 50, height: 55)
        
        topView.addSubview(myFirstButton)
        
        let nameLabel = UILabel()
        
        nameLabel.frame = CGRect(x: 120, y:30, width: 140, height: 55)
        
        nameLabel.textColor = UIColor.black
        
        // nameLabel.text = customerName
        
        topView.addSubview(nameLabel)
        
        let image = UIImageView()
        
        image.frame = CGRect(x: 60, y:33, width: 48, height: 48)
        
        image.cornerRadius = 24
        
        //  let url = NSURL(string: (customerImage))
        
        //  image.sd_setImage(with: url! as URL, placeholderImage: #imageLiteral(resourceName: "team"))
        
        topView.addSubview(image)
        
        //        UIWindow.key?.addSubview(topView)
        
        //        appDelegate.window?.addSubview(topView)
        
        view.addSubview(topView)
    }
    
    override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                
                // required for iOS 11
                textInputbar.bringSubviewToFront(textInputbar.textView)
                textInputbar.bringSubviewToFront(textInputbar.leftButton)
                textInputbar.bringSubviewToFront(textInputbar.rightButton)
                
          }
    
    
    @objc func pressed() {
        topView.frame = CGRect(x: 15, y:50, width: 0, height: 0)
        topView.removeFromSuperview()
        self.navigationController?.popViewController(animated:true)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> Int {
                return 4//messages.count
            }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        let message = sortedMessages[indexPath.row]
        
        cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
        
        
        cell.transform = tableView.transform
        
        return cell
        
    }
    
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: "") -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainChatViewController.TWCChatCellIdentifier, for:indexPath as IndexPath)
        
        let chatCell: ChatTVCell = cell as! ChatTVCell
        let date = NSDate.dateWithISO8601String(dateString: message.dateCreated ?? "")
        let timestamp = DateTodayFormatter().stringFromDate(date: date)
        
        chatCell.setUser(user: message.author ?? "[Unknown author]", message: message.body, date: timestamp ?? "[Unknown date]")
        //            debugPrint(currentUserLogin.firstName + " " + currentUserLogin.lastName)
        //
        //            debugPrint(message.author)
        
        if currentUserLogin.firstName + " " + currentUserLogin.lastName == message.author ?? "[Unknown author]"
            
        {
            //            chatCell.heightCustomerView.constant = 0
            
            chatCell.viewCustomer.isHidden = true
        }
        
        else{
            //            chatCell.heightUserView.constant = 0
            
            chatCell.viewUser.isHidden = true
            
        }
        return chatCell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
}
