//  CountryState.swift
//  Dawadawa
//  Created by Ritesh Gupta on 08/12/22.

import Foundation

class Country{
    var name:String?
    var iso3:String?
    var iso2:String?
    var state = [StateData]()
    init(data: [String: Any]) {
        self.name = String.getString(data["name"])
        self.iso3 = String.getString(data["iso3"])
        self.iso2 = String.getString(data["iso2"])
        let data = kSharedInstance.getArray(data["states"])
        self.state = data.map{StateData(data: kSharedInstance.getDictionary($0))}
    }
}

class StateData{
    var name:String?
    var state:String?
    
    init(data:[String:Any]) {
        self.name = String.getString(data["name"])
        self.state = String.getString(data["state_code"])
    }
}
