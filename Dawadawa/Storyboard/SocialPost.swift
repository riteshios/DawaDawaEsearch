//
//  SocialPost.swift
//  Dawadawa
//
//  Created by Alekh on 22/07/22.
//

import Foundation

// Model for all and Profile Post Opportunity
class SocialPostData {
    
    var id:Int?
    var title:String?
    var oppr_type:String?
    var category_id:Int?
    var business_name:String?
    var services_type:String?
    var business_mining_type:String?
    var business_mining_block:String?
    var opp_state:String?
    var opp_locality:String?
    var location_name:String?
    var location_map:String?
    var description:String?
    var likes:Int?
    var mobile_num:String?
    var whatsaap_num:String?
    var pricing:String?
    var looking_for:String?
    var opp_plan:String?
    var flag_user_post:String?
    var is_user_like:String?
    var oppimage = [oppr_image]() // Array of dictionary
    var userdetail:user_detail?  // Simple dictionary
    var oppdocument = [oppr_document]()  // Array of dictionary
    
   
    init(data: [String: Any]) {
        self.id = Int.getInt(data["id"])
        self.title = String.getString(data["title"])
        self.oppr_type = String.getString(data["oppr_type"])
        self.category_id = Int.getInt(data["category_id"])
        self.business_name = String.getString(data["business_name"])
        self.services_type = String.getString(data["services_type"])
        self.business_mining_type = String.getString(data["business_mining_type"])
        self.business_mining_block = String.getString(data["business_mining_block"])
        self.opp_state = String.getString(data["opp_state"])
        self.opp_locality = String.getString(data["opp_locality"])
        self.location_name = String.getString(data["location_name"])
        self.location_map = String.getString(data["location_map"])
        self.description = String.getString(data["description"])
        self.likes = Int.getInt(data["likes"])
        self.mobile_num = String.getString(data["mobile_num"])
        self.whatsaap_num = String.getString(data["whatsaap_num"])
        self.pricing = String.getString(data["pricing"])
        self.looking_for = String.getString(data["looking_for"])
        self.opp_plan = String.getString(data["opp_plan"])
        self.is_user_like = String.getString(data["is_user_like"])
        let img = kSharedInstance.getArray(withDictionary: data["oppr_image"])
        self.oppimage = img.map{oppr_image(data: kSharedInstance.getDictionary($0))}
        self.userdetail = user_detail(data: kSharedInstance.getDictionary(data["user_detail"]))
        
    }
    
}

class oppr_image{
    var image:String?
    
    init(data:[String:Any]){
        self.image = String.getString(data["image"])
    }
}

class user_detail{
    var g_id:String?
    var name:String?
    var social_profile:String?
    
    init(data:[String:Any]){
        self.g_id = String.getString(data["g_id"])
        self.name = String.getString(data["name"])
        self.social_profile = String.getString(data["social_profile"])
    }
}

class oppr_document{
    var id:Int?
    var opportunity_id:Int?
    var oppr_document:String?
  
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.opportunity_id = Int.getInt(data["opportunity_id"])
        self.oppr_document = String.getString(data["oppr_document"])
    }
}

