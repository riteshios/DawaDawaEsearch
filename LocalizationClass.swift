//  LocalizationClass.swift
//  Dawadawa
//  Created by Ritesh Gupta on 06/07/22.


import UIKit
import Foundation

class AppHelper: NSObject {

    static func getLocalizeString(str:String) -> String {
        let string = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "Language"), ofType: "lproj")
        let myBundle = Bundle(path: string!)
        return (myBundle?.localizedString(forKey: str, value: "", table: nil))!
    }
}
