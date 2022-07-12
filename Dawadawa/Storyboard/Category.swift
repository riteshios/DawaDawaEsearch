//
//  Category.swift
//  Dawadawa
//
//  Created by Ritesh on 08/07/22.
//

import Foundation
import SwiftyJSON

//class getCartegoryModel{
//    let id: Int?
//    let category_name: String?
//    let cat_image: String?
//    init(data:[String:Any]){
//        self.id = Int.getInt(data["id"])
//        self.category_name = String.getString(data["category_name"])
//        self.cat_image = String.getString(data["cat_image"])
//    }
//}


class getCartegoryModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case category_name = "category_name"
        case cat_image = "cat_image"
    }
    var id = ""
    var category_name = ""
    var cat_image = ""
    
    
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? String{
            self.id = id
        }
        if let category_name = dictionary[keys.category_name.stringValue] as? String{
            self.category_name = category_name
        }
        if let cat_image = dictionary[keys.cat_image.stringValue] as? String{
            self.cat_image = cat_image
            
        }
        super.init()
    }
}
class getSubCartegoryModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case sub_cat_name = "sub_cat_name"
        
    }
    var id:Int?
    var sub_cat_name = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? Int{
            self.id = id
        }
        if let sub_cat_name = dictionary[keys.sub_cat_name.stringValue] as? String{
            self.sub_cat_name = sub_cat_name
        }
        super.init()
    }
}
class getStateModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case state_name = "state_name"
        
    }
    var id:Int?
    var state_name = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? Int{
            self.id = id
         
            
        }
        if let state_name = dictionary[keys.state_name.stringValue] as? String{
            self.state_name = state_name
        }
        super.init()
    }
}

class getLocalityModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case local_name = "local_name"
        
    }
    var id = ""
    var local_name = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? String{
            self.id = id
        }
        if let local_name = dictionary[keys.local_name.stringValue] as? String{
            self.local_name = local_name
        }
        super.init()
    }
}


// Create Opportunity Model

class categorydata{
    static let shared = categorydata()
//    var id:Int?
    var category_id:Int?
    var sub_category:Int?
    var title:String?
    var opp_state:String?
    var opp_locality:String?
    var location_name:String?
    var location_map:String?
    var description:String?
    var mobile_num:String?
    var whatspp_number:String?
    var whatsaap_num:String?
    var pricing:String?
    var looking_for:String?
    var plan:String?
    var filenames = [Any]()
    var opportunity_documents = [Any]()
    var cat_type_id:Int?
    
    
    private init(){
        let  data:[String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
        saveData(data:data,token: kSharedUserDefaults.getLoggedInAccessToken())
    }
    func saveData(data:[String:Any],token:String){
//        self.id = Int.getInt(data["id"])
        self.category_id = Int.getInt(data["category_id"])
        self.sub_category = Int.getInt(data["sub_category"])
        self.title = String.getString(data["title"])
        self.opp_state = String.getString(data["opp_state"])
        self.opp_locality = String.getString(data["opp_locality"])
        self.location_name = String.getString(data["location_name"])
        self.location_map = String.getString(data["location_map"])
        self.description = String.getString(data["description"])
        self.mobile_num = String.getString(data["mobile_num"])
        self.whatsaap_num = String.getString(data["whatsaap_num"])
        self.pricing = String.getString(data["pricing"])
        self.looking_for = String.getString(data["looking_for"])
        self.plan = String.getString(data["plan"])
        self.filenames = (data["filenames"]) as! [Any]
        self.opportunity_documents = (data["device_id"]) as! [Any]
        self.cat_type_id = Int.getInt(data["cat_type_id"])
        
        kSharedUserDefaults.getLoggedInUserDetails()
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken:token)
        
    }
    
}

