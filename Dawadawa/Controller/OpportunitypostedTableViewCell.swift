//  OpportunitypostedTableViewCell.swift
//  Dawadawa
//  Created by Ritesh Gupta on 21/07/22.

import UIKit

class OpportunitypostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblshowdata: UILabel!
    @IBOutlet weak var lbltotalused: UILabel!
    @IBOutlet weak var lblshowplan: UILabel!
    @IBOutlet weak var lblshowOpportunity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblOpportunity: UILabel!
    
    @IBOutlet weak var viewAllline:UIView!
    @IBOutlet weak var viewPremiumLine:UIView!
    @IBOutlet weak var viewFeaturedLine:UIView!
    
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblpremium: UILabel!
    @IBOutlet weak var lblFeatured: UILabel!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnPremium: UIButton!
    @IBOutlet weak var btnFeatured: UIButton!
    
//    @IBOutlet weak var imgOppPosted: UIImageView!
    
    var callbackbtnSelect:((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setuplanguage()
        self.viewAllline.isHidden = false
        self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewPremiumLine.isHidden = true
        self.viewFeaturedLine.isHidden = true
      
    }

    @IBAction func btnAllTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnAll.isSelected == true{
           
            self.viewAllline.isHidden = false
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewPremiumLine.isHidden = true
            self.viewFeaturedLine.isHidden = true
            self.lblpremium.textColor = .gray
            self.lblFeatured.textColor = .gray
            
            self.callbackbtnSelect?("All")
        }
       
    }
    
    @IBAction func btnPremiumTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if self.btnPremium.isSelected == true{
            self.viewAllline.isHidden = true
            self.lblAll.textColor = .gray
            self.viewPremiumLine.isHidden = false
            self.viewFeaturedLine.isHidden = true
            self.lblpremium.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblFeatured.textColor = .gray
            self.callbackbtnSelect?("Premium")
        }
    }
    
    @IBAction func btnFeaturedTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if self.btnFeatured.isSelected == true{
           
            self.viewAllline.isHidden = true
            self.lblAll.textColor = .gray
            self.viewPremiumLine.isHidden = true
            self.viewFeaturedLine.isHidden = false
            self.lblpremium.textColor = .gray
            self.lblFeatured.textColor =  UIColor(red: 21, green: 114, blue: 161)
            
            self.callbackbtnSelect?("Featured")
    }
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

// MARK: - Localisation

extension OpportunitypostedTableViewCell{
    func setuplanguage(){
        lblAll.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "All", comment: "")
        lblpremium.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Premium", comment: "")
        lblFeatured.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Featured", comment: "")
    }
}
