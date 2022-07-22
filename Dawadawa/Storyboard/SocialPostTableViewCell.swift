//
//  SocialPostTableViewCell.swift
//  Dawadawa
//
//  Created by Alekh on 20/07/22.
//

import UIKit

class SocialPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var SocialPostCollectionView: UICollectionView!
    var callbackmore:(()->())?
 
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var Imageuser: UIImageView!
    
    var img = [oppr_image](){
        didSet{
            pageControl.isHidden = true
            pageControl.numberOfPages = img.count
            self.SocialPostCollectionView.reloadData()
        }
    }
    var imgUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.awakeFromNib()
        SocialPostCollectionView.delegate = self
        SocialPostCollectionView.dataSource = self
        SocialPostCollectionView.register(UINib(nibName: "SocialPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialPostCollectionViewCell")
        pageControl.numberOfPages = img.count
        pageControl.currentPage = 0
      
      
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callbackmore?()
    }
    
    
}
extension SocialPostTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
//    Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialPostCollectionView.dequeueReusableCell(withReuseIdentifier: "SocialPostCollectionViewCell", for: indexPath) as! SocialPostCollectionViewCell
        let obj = img[indexPath.item].image
        print("-=-img-=-\(obj)")
        let imageurl = "\(imgUrl)\(String.getString(obj))"
        print("-=imageurl=-=-\(imageurl)")
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: nil)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
