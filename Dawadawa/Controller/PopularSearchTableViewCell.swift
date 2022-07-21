//
//  PopularSearchTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PopularSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SearchCollectionView: UICollectionView!
   var titles = [
        "Driver tracking",
        "Employee tracking",
        "Driver dispatch",
        "Track package",
        "Track lost device",
        "I need a job",
        "I need an employee",
        "Other"]
    

    override func awakeFromNib() {
        super.awakeFromNib()
        SearchCollectionView.delegate = self
        SearchCollectionView.dataSource = self
        SearchCollectionView.register(UINib(nibName: "PopularSearchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularSearchesCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

extension PopularSearchTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchesCollectionViewCell",for: indexPath) as? PopularSearchesCollectionViewCell
        else {
            return PopularSearchesCollectionViewCell()
        }
        cell.lblPopularSearch.text = titles[indexPath.row]
        cell.lblPopularSearch.preferredMaxLayoutWidth = collectionView.frame.width - 16
        return cell
    }
    
    
}
