//
//  HomeVC.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class HomeVC: UIViewController{
    

    @IBOutlet weak var tblViewViewPost: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewViewPost.register(UINib(nibName: "ViewPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ViewPostTableViewCell")
        
    }
    

  
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
//        return cell
//
//
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            return cell
            
            
        default:
            return UITableViewCell()
        }
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 420
            
        default:
            return 0
        }
        
    }
    
    
}
