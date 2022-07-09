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
