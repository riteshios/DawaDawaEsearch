//
//  userData.swift
//  Dawadawa
//
//  Created by Alekh on 23/06/22.
//

import Foundation
class UserData{
    static let shared = UserData()
    var id:String?
    var firstname:String?
    var lastname:String?
    var email:String?
    var phone:String?
    var images:String?
    var editProfile = false
    var countryCode:String?
    var profilePic:String?
    var isimageSelected = false
    var countData:Int?
  
   private init(){
       let  data:[String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
       saveData(data:data)
   }
    func saveData(data:[String:Any]){
        self.id = String.getString(data["_id"])
        self.firstname = String.getString(data["firstname"])
        self.lastname = String.getString(data["lastname"])
        self.email = String.getString(data["email"])
        self.phone = String.getString(data["phone"])
        self.images = String.getString(data["images"])
        self.countryCode = String.getString(data["country_code"])
        self.profilePic = String.getString(data["profile_pic"])
        kSharedUserDefaults.getLoggedInUserDetails()
        
    }

}
