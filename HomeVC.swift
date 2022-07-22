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
        tblViewViewPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SocialPostTableViewCell")
      
    }
    

  
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
   
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
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "ViewPostTableViewCell") as! ViewPostTableViewCell
            cell.ColllectionViewPremiumOpp.tag = indexPath.section
            cell.callbacknavigation = {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: PremiumOpportunitiesVC.getStoryboardID()) as! PremiumOpportunitiesVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell
            
        case 1:
            let cell = self.tblViewViewPost.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
            cell.SocialPostCollectionView.tag = indexPath.section
            cell.callbackmore = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: HomeSocialMoreVC.getStoryboardID()) as! HomeSocialMoreVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                vc.callback = { txt in
//                    if txt == "Dismiss"{
//                        vc.dismiss(animated: false){
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }
                    if txt == "Flag"{
                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    
                    if txt == "Report"{
                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    
                }
                self.present(vc, animated: false)
            }
            return cell
        
            
            
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 420
        case 1:
            return UITableView.automaticDimension
        
        default:
            return 0
        }
        
    }
    
    
}
