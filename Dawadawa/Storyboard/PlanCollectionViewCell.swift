//
//  PlanCollectionViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 02/08/22.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var PlantableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PlantableView.delegate = self
        PlantableView.dataSource = self
        
        PlantableView.register(UINib(nibName: "PlanTableViewCell", bundle: nil), forCellReuseIdentifier: "PlanTableViewCell")
        PlantableView.register(UINib(nibName: "PlanListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlanListTableViewCell")
        
    }

}
extension PlanCollectionViewCell: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        
        case 1:
            return 12
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = self.PlantableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell") as! PlanTableViewCell
            return cell
        
        case 1:
            let cell = self.PlantableView.dequeueReusableCell(withIdentifier: "PlanListTableViewCell") as! PlanListTableViewCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 130
        case 1:
            return UITableView.automaticDimension
        
        default:
            return 0
        }
        
    }
    
    
}
