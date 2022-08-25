//
//  Comment.swift
//  Dawadawa
//
//  Created by Alekh on 22/08/22.
//

import Foundation
import UIKit

class CommentData{
    
    var id:Int?
    var user_id:Int?
    var opr_id:Int?
    var comments:String?
    var name:String?
    var image:String?
//    var subcomment = [sub_comment]()
    
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.opr_id = Int.getInt(data["opr_id"])
        self.comments = String.getString(data["comments"])
        self.name = String.getString(data["name"])
        self.image = String.getString(data["image"])
        
//        let subcomment = kSharedInstance.getArray(withDictionary: data["subcomment"])
//        self.subcomment = subcomment.map{sub_comment(data: kSharedInstance.getDictionary($0))}
        
    }
    
}


//class sub_comment{
//    var id:Int?
//    var user_id:Int?
//    var comments:String?
//
//    init(data:[String:Any]){
//        self.id = Int.getInt(data["id"])
//        self.user_id = Int.getInt(data["user_id"])
//        self.comments = String.getString(data["comments"])
//    }
//}
