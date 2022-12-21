//  PopularSearchTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 21/07/22

import UIKit

class PopularSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SearchCollectionView: UICollectionView!
    @IBOutlet weak var lblPopularSearch: UILabel!
    
   var titlesen = [
        "Mining Services",
        "Extraction Services",
        "Tailing",
        "Premium Opportunities"]
    
    var titlesar = ["خدمات التعدين","خدمات الاستخراج","مخلفات","فرص مميزة"]
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        SearchCollectionView.delegate = self
        SearchCollectionView.dataSource = self
        SearchCollectionView.register(UINib(nibName: "PopularSearchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularSearchesCollectionViewCell")
        self.lblPopularSearch.isHidden = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PopularSearchTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "PopularSearchesCollectionViewCell",for: indexPath) as? PopularSearchesCollectionViewCell
        else {
            return PopularSearchesCollectionViewCell()
        }
        
        if kSharedUserDefaults.getlanguage() as? String == "en"{
            cell.lblPopularSearch.text = titlesen[indexPath.row]
        }
        else{
            cell.lblPopularSearch.text = titlesar[indexPath.row]
        }
        cell.lblPopularSearch.preferredMaxLayoutWidth = collectionView.frame.width - 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
                label.text = titlesen[indexPath.item]
                label.sizeToFit()
                return CGSize(width: label.frame.width + 20, height: 40)
    }
}


// MARK: - Localisation

extension PopularSearchTableViewCell{
    func setuplanguage(){
        lblPopularSearch.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Popular searches", comment: "")
    }
}
