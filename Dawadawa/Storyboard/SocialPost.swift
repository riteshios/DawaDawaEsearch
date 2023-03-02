//  SocialPost.swift
//  Dawadawa
//  Created by Ritesh Gupta on 22/07/22.

import Foundation
import UIKit
import SwiftyJSON

// Model for all and Profile Post Opportunity
class SocialPostData {
    
    var id:Int?
    var user_id:Int?
    var title:String?
    var oppr_type:String?
    var category_id:String?
    var business_name:String?
    var subcategory_name:String?
    var services_type:String?
    var business_mining_type:String?
    var business_mining_block:String?
    var opp_state:String?
    var opp_locality:String?
    var location_name:String?
    var location_map:String?
    var latitude:String?
    var longitude:String?
    var description:String?
    var likes:Int?
    var opr_rating:String?
    var is_flag:String?
    var category_name:String?
    var mobile_num:String?
    var whatsaap_num:String?
    var pricing:String?
    var looking_for:String?
    var close_opr:Int?
    var opp_plan:String?
    var flag_user_post:Int?
    var is_user_like:String?
    var is_saved:String?
    var plan_name:String?
    var share_link:String?
    var commentsCount:Int?
    var isComment = false
    var oppimage = [oppr_image]() // Array of dictionary
    var userdetail:user_detail?  // Simple dictionary
    var oppdocument = [oppr_document]()  // Array of dictionary
    var usercomment = [user_comment]() // Array of dictionary
    
    init(data: [String: Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.title = String.getString(data["title"])
        self.oppr_type = String.getString(data["oppr_type"])
        self.category_id = String.getString(data["category_id"])
        self.business_name = String.getString(data["business_name"])
        self.subcategory_name = String.getString(data["subcategory_name"])
        self.services_type = String.getString(data["services_type"])
        self.business_mining_type = String.getString(data["business_mining_type"])
        self.business_mining_block = String.getString(data["business_mining_block"])
        self.opp_state = String.getString(data["opp_state"])
        self.opp_locality = String.getString(data["opp_locality"])
        self.location_name = String.getString(data["location_name"])
        self.location_map = String.getString(data["location_map"])
        self.latitude = String.getString(data["latitude"])
        self.longitude = String.getString(data["longitude"])
        self.description = String.getString(data["description"])
        self.likes = Int.getInt(data["likes"])
        self.opr_rating = String.getString(data["opr_rating"])
        self.is_flag = String.getString(data["is_flag"])
        self.category_name = String.getString(data["category_name"])
        self.mobile_num = String.getString(data["mobile_num"])
        self.whatsaap_num = String.getString(data["whatsaap_num"])
        self.pricing = String.getString(data["pricing"])
        self.looking_for = String.getString(data["looking_for"])
        self.close_opr = Int.getInt(data["close_opr"])
        self.flag_user_post = Int.getInt(data["flag_user_post"])
        self.opp_plan = String.getString(data["opp_plan"])
        self.is_user_like = String.getString(data["is_user_like"])
        self.is_saved = String.getString(data["is_saved"])
        self.plan_name = String.getString(data["plan_name"])
        self.share_link = String.getString(data["share_link"])
        self.commentsCount = Int.getInt(data["commentsCount"])
        
        let img = kSharedInstance.getArray(withDictionary: data["oppr_image"])
        self.oppimage = img.map{oppr_image(data: kSharedInstance.getDictionary($0))}
        
        self.userdetail = user_detail(data: kSharedInstance.getDictionary(data["user_detail"]))
        
        let doc = kSharedInstance.getArray(withDictionary: data["oppr_document"])
        self.oppdocument = doc.map{oppr_document(data: kSharedInstance.getDictionary($0))}
        
        let comment = kSharedInstance.getArray(withDictionary: data["user_comment"])
        self.usercomment = comment.map{user_comment(data: kSharedInstance.getDictionary($0))}
        
    }
    
}
// Plan_amount

class plan_amount{
    
    var id:Int?
    var opr_plan:String?
    var amount:Int?
    var type:String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.opr_plan = String.getString(data["opr_plan"])
        self.amount = Int.getInt(data["amount"])
        self.type = String.getString(data["type"])
    }
}

class oppr_image{
    var id:Int?
    var imageurl:String?
    var img:UIImage?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.imageurl = String.getString(data["image"])
        self.img = nil
    }
}

class user_detail{ // Also use for MYChat List
    var id:String?
    var name:String?
    var email:String?
    var social_profile:String?
    var image:String?// for details screen
    var unread:Int?
    
    init(data:[String:Any]){
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.email = String.getString(data["email"])
        self.social_profile = String.getString(data["social_profile"])
        self.image = String.getString(data["image"])
        self.unread = Int.getInt(data["unread"])
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

// Comment

class user_comment{
    var id:Int?
    var user_id:Int?
    var comments:String?
    var name:String?
    var image:String?
    var isReply = false
    var subcomment = [sub_Comment]()
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.comments = String.getString(data["comments"])
        self.name = String.getString(data["name"])
        self.image = String.getString(data["image"])
        
        let Subcomment = kSharedInstance.getArray(withDictionary: data["subcomment"])
        self.subcomment = Subcomment.map{sub_Comment(data: kSharedInstance.getDictionary($0))}
    }
}

// Sub-Comment
class sub_Comment{
    
    var comments:String?
    var usersubcommentdetails:subcomment_userdetails?
    
    init(data:[String:Any]){
        
        self.comments = String.getString(data["comments"])
        self.usersubcommentdetails = subcomment_userdetails(data: kSharedInstance.getDictionary(data["user"]))
        
    }
    
}


class subcomment_userdetails{
    var id:Int?
    var name:String?
    var last_name:String?
    var image:String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.name = String.getString(data["name"])
        self.last_name = String.getString(data["last_name"])
        self.image = String.getString(data["image"])
    }
}

class user_Data{
    
    var name:String?
    var email:String?
    var user_status:String?
    var phone:String?
    var rating:String?
    var user_type:String?
    var about:String?
    var image:String?
    
    init(data:[String:Any]){
        self.name = String.getString(data["name"])
        self.email = String.getString(data["email"])
        self.user_status = String.getString(data["user_status"])
        self.phone = String.getString(data["phone"])
        self.rating = String.getString(data["rating"])
        self.user_type = String.getString(data["user_type"])
        self.about = String.getString(data["about"])
        self.image = String.getString(data["image"])
    }
}


// MARK: -  GetSubscriptionPlan

class Subscription_data{
    
    var id:Int?
    var user_type:String?
    var type:String?
    var title:String?
    var planNmae:String? // response m yhi key aa rha h
    var price_month:String?
    var price_year:String?
    var cut_year_price:String?
    var no_create:String?
    var image:String
    var description = [description_plan]()
    
    init(data:[String:Any]){
        
        self.id = Int.getInt(data["id"])
        self.user_type = String.getString(data["user_type"])
        self.type = String.getString(data["type"])
        self.title = String.getString(data["title"])
        self.planNmae = String.getString(data["planNmae"])
        self.price_month = String.getString(data["price_month"])
        self.price_year = String.getString(data["price_year"])
        self.cut_year_price = String.getString(data["cut_year_price"])
        self.no_create = String.getString(data["no_create"])
        self.image = String.getString(data["image"])
        
        let descri = kSharedInstance.getArray(withDictionary: data["description"])
        self.description = descri.map{description_plan(data: kSharedInstance.getDictionary($0))}
    }
}


class description_plan{
    
    var key:String?
    
    init(data:[String:Any]){
        self.key = String.getString(data["key"])
    }
}

// Data dashboard

class data_dashboard{
    var expiry_date:String?
    var plan_type:String?
    var no_saved:String?
    var total_create:String?
    var total_used:String?
    var no_view:String?
    var no_flag:String?
    
    init(data:[String:Any]){
        self.expiry_date = String.getString(data["expiry_date"])
        self.plan_type = String.getString(data["plan_type"])
        self.no_saved = String.getString(data["no_saved"])
        self.total_create = String.getString(data["total_create"])
        self.total_used = String.getString(data["total_used"])
        self.no_view = String.getString(data["no_view"])
        self.no_flag = String.getString(data["no_flag"])
    }
}

// Active Plan

class active_plan{
    var id:Int?
    var package_id:Int?
    var package_name:String?
    var end_date:String?
    var balacedata:balance_data?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.package_id = Int.getInt(data["package_id"])
        self.package_name = String.getString(data["package_name"])
        self.end_date = String.getString(data["end_date"])
        self.balacedata = balance_data(data: kSharedInstance.getDictionary(data["balance_data"]))
        
    }
}

// Balance_data
class balance_data{
    var total_no_create:String?
    var total_no_used:String?
    var left_bal:String?
    
    init(data:[String:Any]){
        self.total_no_create = String.getString(data["total_no_create"])
        self.total_no_used = String.getString(data["total_no_used"])
        self.left_bal = String.getString(data["left_bal"])
    }
}
// Get transaction History

class trans_history{
    var id:Int?
    var amount:String?
    var transaction_id:String?
    var transaction_date:String?
    var package:pac_kage?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.amount = String.getString(data["amount"])
        self.transaction_id = String.getString(data["transaction_id"])
        self.transaction_date = String.getString(data["transaction_date"])
        self.package = pac_kage(data: kSharedInstance.getDictionary(data["package"]))
    }
}

class pac_kage{
    var id:Int?
    var title:String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.title = String.getString(data["title"])
    }
}


// Payment

struct SecretKeyParser {

    var clientSecret = ""
    
    init(_ json: JSON) {
        clientSecret = json["paymentIntent"].stringValue

    }
}

// AllNotification_data

class Notification_data{
    var id:Int?
    var user_id:Int?
    var title:String?
    var body:String?
    var read_status:String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.title = String.getString(data["title"])
        self.body = String.getString(data["body"])
        self.read_status = String.getString(data["read_status"])
    }
}

// Message_data

class Message_data{
    var id:Int?
    var from:Int?
    var to:Int?
    var message:String?
    var is_read:Int?
    var created_at:String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.from = Int.getInt(data["from"])
        self.to = Int.getInt(data["to"])
        self.message = String.getString(data["message"])
        self.is_read = Int.getInt(data["is_read"])
        self.created_at = String.getString(data["created_at"])
    }
}
