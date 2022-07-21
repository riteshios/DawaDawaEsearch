//
//  SearchVC.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tblViewSearchOpp: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tblViewSearchOpp.register(UINib(nibName: "PopularSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PopularSearchTableViewCell")
        
        tblViewSearchOpp.register(UINib(nibName: "PremiumOppTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PremiumOppTableViewCell")
        
        
       
    }
    


}
extension SearchVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
            
        case 1:
            return 1
            
 

            
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PopularSearchTableViewCell") as! PopularSearchTableViewCell
            cell.SearchCollectionView.tag = indexPath.section
            return cell
            
        case 1:
            let cell = self.tblViewSearchOpp.dequeueReusableCell(withIdentifier: "PremiumOppTableViewCell") as! PremiumOppTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            return cell
        
            
            
        default:
            return UITableViewCell()
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 195
        case 1:
            return UITableView.automaticDimension
//
        default:
            return 0
        }
        
    }
    
}
