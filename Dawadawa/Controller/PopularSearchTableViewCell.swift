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
        "Search #01",
        "Search #02",
        "Search #03",
        "Search #04",
        "Popular Search #08",
        "Minimng",
        "Search #099",
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
       return titles.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchesCollectionViewCell",for: indexPath) as? PopularSearchesCollectionViewCell
        else {
            return PopularSearchesCollectionViewCell()
        }
        cell.lblPopularSearch.text = titles[indexPath.row]
        cell.lblPopularSearch.preferredMaxLayoutWidth = collectionView.frame.width - 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
                label.text = titles[indexPath.item]
                label.sizeToFit()
                return CGSize(width: label.frame.width + 20, height: 40)
    }
}
