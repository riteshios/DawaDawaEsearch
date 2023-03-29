//  Navigator.swift
//  Dawadawa
//  Created by Ritesh Gupta on 10/10/22.

import Foundation
import UIKit

struct Navigator {
    
    func getDestination(for url:URL) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let tabbarcontroller = storyboard.instantiateInitialViewController() as? UITabBarController
        tabbarcontroller?.selectedIndex = 0
        
        let destination = Destination(for: url)
        
        switch destination {
        case .users:
            return tabbarcontroller
        case .userDetails(let userId):
            
            let navController = tabbarcontroller!.viewControllers?[0] as? UINavigationController
            
            guard let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return nil}
            return tabbarcontroller
            
        case.safari: return nil
        }
        
    }
}

enum Destination{
    case users
    case userDetails(Int)
    case safari
    init(for url : URL){
        print(url.lastPathComponent)
        
        if url.lastPathComponent == "users"{
            self = .users
        }
        else if let userId = Int(url.lastPathComponent){
            self = .userDetails(userId)
        }
        else{
            self = .safari
        }
        
    }
}
