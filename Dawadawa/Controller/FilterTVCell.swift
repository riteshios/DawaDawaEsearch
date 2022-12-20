//  FilterTVCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 24/11/22.

import UIKit

class FilterTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var lblClear: UILabel!
    
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var viewBG: UIView!
    
    var textArray:[String] = []{
        didSet{
            collectionview.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "FilterDataCVCell", bundle: nil), forCellWithReuseIdentifier: "FilterDataCVCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FilterTVCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "FilterDataCVCell", for: indexPath) as! FilterDataCVCell
        let obj = textArray[indexPath.item]
        cell.labelFiltered.text = String.getString(obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
            label.text = textArray[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20, height: 40)
        }
}

// MARK: - Localisation

extension FilterTVCell{
    func setuplanguage(){
        lblFilter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Filters", comment: "")
        lblClear.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Clear", comment: "")
    }
}
