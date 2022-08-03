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
    var callback:((String)->())?
    
 
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var Imageuser: UIImageView!
    
    @IBOutlet weak var imgOpp_plan: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var imglike: UIImageView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var lbllike: UILabel!
    
   
    var imgUrl = ""
    var userTimeLine = [SocialPostData]()
    var img = [oppr_image](){
        didSet{
            pageControl.isHidden = true
            pageControl.numberOfPages = img.count
            self.SocialPostCollectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SocialPostCollectionView.delegate = self
        SocialPostCollectionView.dataSource = self
        SocialPostCollectionView.register(UINib(nibName: "SocialPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialPostCollectionViewCell")
        pageControl.numberOfPages = img.count
        pageControl.currentPage = 0
      
      
    }
    
    func setup(){
    
        
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.callback?("More")
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.callback?("Like")
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
        print("-=-imgurl-=-\(obj)")
        let imageurl = "\(imgUrl)\(String.getString(obj))"
        print("-=imagebaseurl=-=-\(imageurl)")
        cell.imgOpportunity.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "baba"))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

