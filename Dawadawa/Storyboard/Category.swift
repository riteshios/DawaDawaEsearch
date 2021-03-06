//
//  Category.swift
//  Dawadawa
//
//  Created by Ritesh on 08/07/22.
//

import Foundation
import SwiftyJSON

// Category Model

class getCartegoryModel{
    let id: Int?
    let category_name: String?
    let cat_image: String?
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.category_name = String.getString(data["category_name"])
        self.cat_image = String.getString(data["cat_image"])
    }
}

// Category Model
//class getCartegoryModel:NSObject{
//    enum keys:String, CodingKey{
//        case id = "id"
//        case category_name = "category_name"
//        case cat_image = "cat_image"
//    }
//    var id = ""
//    var category_name = ""
//    var cat_image = ""
//
//
//
//    override init(){
//        super.init()
//
//    }
//    init(dictionary:[String:AnyObject]){
//        if let id = dictionary[keys.id.stringValue] as? String{
//            self.id = id
//        }
//        if let category_name = dictionary[keys.category_name.stringValue] as? String{
//            self.category_name = category_name
//        }
//        if let cat_image = dictionary[keys.cat_image.stringValue] as? String{
//            self.cat_image = cat_image
//
//        }
//        super.init()
//    }
//}


// SubCategory Model
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
// State Model
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

// Locality Model
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

// Looking For Model

class getLookingForModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case looking_for = "looking_for"
        
    }
    var id:Int?
    var looking_for = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? Int{
            self.id = id
        }
        if let looking_for = dictionary[keys.looking_for.stringValue] as? String{
            self.looking_for = looking_for
        }
        super.init()
    }
}

// Service_Type Model
class getserviceTypeModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case services_type = "services_type"
        
    }
    var id:Int?
    var services_type = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? Int{
            self.id = id
        }
        if let services_type = dictionary[keys.services_type.stringValue] as? String{
            self.services_type = services_type
        }
        super.init()
    }
}

// Business_Type_Model
class getbusinessminingTypeModel:NSObject{
    enum keys:String, CodingKey{
        case id = "id"
        case business_mining_type = "business_mining_type"
        
    }
    var id:Int?
    var business_mining_type = ""
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let id = dictionary[keys.id.stringValue] as? Int{
            self.id = id
        }
        if let business_mining_type = dictionary[keys.business_mining_type.stringValue] as? String{
            self.business_mining_type = business_mining_type
        }
        super.init()
    }
}
// Create Opportunity Model

class opportunityydataModel:NSObject{
    enum keys:String, CodingKey{
        
        case category_id = "category_id"
        case sub_category = "sub_category"
        case title = "title"
        case opp_state = "opp_state"
        case opp_locality = "opp_locality"
        case location_name = "location_name"
        case location_map = "location_map"
        case description = "description"
        case mobile_num = "mobile_num"
        case whatspp_number = "whatspp_number"
        case pricing = "pricing"
        case looking_for = "looking_for"
        case plan = "plan"
        case filenames = "filenames"
        case opportunity_documents = "opportunity_documents"
        case cat_type_id = "cat_type_id"

    }
    var category_id:Int?
    var sub_category:Int?
    var title = ""
    var opp_state = ""
    var opp_locality = ""
    var location_name = ""
    var location_map = ""
    var descriptions = ""
    var mobile_num = ""
    var whatspp_number = ""
    var pricing = ""
    var looking_for = ""
    var plan = ""
    var filenames = ""
    var opportunity_documents = ""
    var cat_type_id = ""
    
    
    override init(){
        super.init()
        
    }
    init(dictionary:[String:AnyObject]){
        if let category_id = dictionary[keys.category_id.stringValue] as? Int{
            self.category_id = category_id
        }
        if let sub_category = dictionary[keys.sub_category.stringValue] as? Int{
            self.sub_category = sub_category
        }
        if let title = dictionary[keys.title.stringValue] as? String{
            self.title = title
        }
        if let opp_state = dictionary[keys.opp_state.stringValue] as? String{
            self.opp_state = opp_state
        }
        if let opp_locality = dictionary[keys.opp_locality.stringValue] as? String{
            self.opp_locality = opp_locality
        }
        if let location_name = dictionary[keys.location_name.stringValue] as? String{
            self.location_name = location_name
        }
        if let location_map = dictionary[keys.location_map.stringValue] as? String{
            self.location_map = location_map
        }
        if let descriptions = dictionary[keys.description.stringValue] as? String{
            self.descriptions = descriptions
        }
        if let mobile_num = dictionary[keys.mobile_num.stringValue] as? String{
            self.mobile_num = mobile_num
        }
        if let pricing = dictionary[keys.pricing.stringValue] as? String{
            self.pricing = pricing
        }
        if let looking_for = dictionary[keys.looking_for.stringValue] as? String{
            self.looking_for = looking_for
        }
        if let plan = dictionary[keys.plan.stringValue] as? String{
            self.plan = plan
        }
        if let filenames = dictionary[keys.filenames.stringValue] as? String{
            self.filenames = filenames
        }
        if let opportunity_documents = dictionary[keys.opportunity_documents.stringValue] as? String{
            self.opportunity_documents = opportunity_documents
        }
        if let cat_type_id = dictionary[keys.cat_type_id.stringValue] as? String{
            self.cat_type_id = cat_type_id
        }
        super.init()
    }
}


//class opportunityydataModel{
//    static let shared = opportunityydataModel()
////    var id:Int?
//    var category_id:Int?
//    var sub_category:Int?
//    var title:String?
//    var opp_state:String?
//    var opp_locality:String?
//    var location_name:String?
//    var location_map:String?
//    var description:String?
//    var mobile_num:String?
//    var whatspp_number:String?
//    var whatsaap_num:String?
//    var pricing:String?
//    var looking_for:String?
//    var plan:String?
//    var filenames = [Any]()
//    var opportunity_documents = [Any]()
//    var cat_type_id:Int?
//
//
//    private init(){
//        let  data:[String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
//        saveData(data:data,token: kSharedUserDefaults.getLoggedInAccessToken())
//    }
//    func saveData(data:[String:Any],token:String){
////        self.id = Int.getInt(data["id"])
//        self.category_id = Int.getInt(data["category_id"])
//        self.sub_category = Int.getInt(data["sub_category"])
//        self.title = String.getString(data["title"])
//        self.opp_state = String.getString(data["opp_state"])
//        self.opp_locality = String.getString(data["opp_locality"])
//        self.location_name = String.getString(data["location_name"])
//        self.location_map = String.getString(data["location_map"])
//        self.description = String.getString(data["description"])
//        self.mobile_num = String.getString(data["mobile_num"])
//        self.whatsaap_num = String.getString(data["whatsaap_num"])
//        self.pricing = String.getString(data["pricing"])
//        self.looking_for = String.getString(data["looking_for"])
//        self.plan = String.getString(data["plan"])
//        self.filenames = (data["filenames"]) as! [Any]
//        self.opportunity_documents = (data["device_id"]) as! [Any]
//        self.cat_type_id = Int.getInt(data["cat_type_id"])
//
//        kSharedUserDefaults.getLoggedInUserDetails()
//        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken:token)
//
//    }
//
//}
//
