//
//  PremiumOpportunitiesVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PremiumOpportunitiesVC: UIViewController {
    
    
    @IBOutlet weak var tblViewPremiumOpp: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewPremiumOpp.register(UINib(nibName: "PremiumTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumTableViewCell")
        tblViewPremiumOpp.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
        
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        kSharedAppDelegate?.makeRootViewController()
    }
    
    
    
}

extension PremiumOpportunitiesVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return 10
            
            
            
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = self.tblViewPremiumOpp.dequeueReusableCell(withIdentifier: "PremiumTableViewCell") as! PremiumTableViewCell
            return cell
            
        case 1:
            let cell = self.tblViewPremiumOpp.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            cell.SocialPostCollectionView.tag = indexPath.section
            return cell
            
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 65
        case 1:
            return UITableView.automaticDimension
        
        default:
            return 0
        }
        
    }
    
}


