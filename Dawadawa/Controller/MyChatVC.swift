//
//  MyChatVC.swift
//  Dawadawa
//
//  Created by Ritesh Gupta on 01/11/22.
//

import UIKit

class MyChatVC: UIViewController {

    @IBOutlet weak var tblviewMyChat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblviewMyChat.register(UINib(nibName: "MyChatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyChatTableViewCell")
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyChatVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return NotificationData.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewMyChat.dequeueReusableCell(withIdentifier: "MyChatTableViewCell") as! MyChatTableViewCell
//        let obj = self.NotificationData[indexPath.row]
//        cell.lblHeading.text = String.getString(obj.title)
//        cell.lblSubheading.text = String.getString(obj.body)
//
//
//        if String.getString(obj.read_status) == "1"{
//            cell.viewNotification.backgroundColor = UIColor.white
//            cell.lblHeading.textColor = UIColor.black
//            cell.lblSubheading.textColor = UIColor.black
//            cell.imglogo.image = UIImage(named: "logo-1")
//        }
//        else if String.getString(obj.read_status) == "0"{
//            cell.viewNotification.backgroundColor = UIColor.init(hexString: "#1572A1")
//            cell.lblHeading.textColor = UIColor.white
//            cell.lblSubheading.textColor = UIColor.white
//            cell.imglogo.image = UIImage(named: "logo")
//        }
//
//
//        cell.callback = { txt, sender in
//
//            if txt == "Notificationdetail"{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationDetail") as! NotificationDetail
//                vc.noti_id = Int.getInt(obj.id)
//                vc.heading = String.getString(obj.title)
//                vc.subheading = String.getString(obj.body)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        return cell
    }
    
}
