//
//  userData.swift
//  Dawadawa
//
//  Created by Alekh on 23/06/22.
//

import Foundation
class UserData{
    static let shared = UserData()
    var id:Int?
    var name:String?
    var last_name:String?
    var email:String?
    var phone:String?
    var user_country:String?
    var language:String?
    var profile_image:String?
    var dob:String?
    var whatspp_number:String?
    var social_profile:String?
    var g_id:String?
    var user_gender:String?
    var user_type:String?
    var device_type:String?
    var device_id:String?
    var google_id:String?
    var facebook_id:String?
    
    private init(){
        let  data:[String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
        saveData(data:data,token: kSharedUserDefaults.getLoggedInAccessToken())
    }
    func saveData(data:[String:Any],token:String){
        self.id = Int.getInt(data["id"])
        self.name = String.getString(data["name"])
        self.last_name = String.getString(data["last_name"])
        self.email = String.getString(data["email"])
        self.phone = String.getString(data["phone"])
        self.user_country = String.getString(data["user_country"])
        self.language = String.getString(data["language"])
        self.profile_image = String.getString(data["profile_image"])
        self.dob = String.getString(data["dob"])
        self.whatspp_number = String.getString(data["whatspp_number"])
        self.social_profile = String.getString(data["social_profile"])
        self.g_id = String.getString(data["g_id"])
        self.user_gender = String.getString(data["user_gender"])
        self.user_type = String.getString(data["user_type"])
        self.device_type = String.getString(data["device_type"])
        self.device_id = String.getString(data["device_id"])
        self.google_id = String.getString(data["google_id"])
        self.facebook_id = String.getString(data["facebook_id"])
        
        kSharedUserDefaults.getLoggedInUserDetails()
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken:token)
        
    }
    
}
