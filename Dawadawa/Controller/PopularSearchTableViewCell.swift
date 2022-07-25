//
//  PopularSearchTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 21/07/22.
//

import UIKit

class PopularSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SearchCollectionView: UICollectionView!
    @IBOutlet weak var lblPopularSearch: UILabel!
    
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
        self.lblPopularSearch.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

extension PopularSearchTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titles.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchesCollectionViewCell",for: indexPath) as? PopularSearchesCollectionViewCell
        else {
            return PopularSearchesCollectionViewCell()
        }
//        cell.lblPopularSearch.text = titles[indexPath.row]
//        cell.lblPopularSearch.preferredMaxLayoutWidth = collectionView.frame.width - 10
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 18)
//    }
  
}
