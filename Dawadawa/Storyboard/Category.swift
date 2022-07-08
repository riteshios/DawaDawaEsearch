//
//  Category.swift
//  Dawadawa
//
//  Created by Ritesh on 08/07/22.
//

import Foundation

class getCartegoryModel{
    let id: Int?
    let category_name: String?
    let cat_image: String?
    init(data:[String:Any]){
        self.id = Int.getInt(data["id"])
        self.category_name = String.getString(data["quantity"])
        self.cat_image = String.getString(data["cat_image"])
    }
}
