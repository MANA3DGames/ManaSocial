//
//  UserData.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/24/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation


// Saved user's data
var userData : NSDictionary?


class UserLocalData
{
    // Key for user saved data.
    static let USER_SAVED_DATA_KEY = "userLoginData"
    
    
    static func save(_ json: [String: Any] )
    {
        UserDefaults.standard.set( json, forKey: USER_SAVED_DATA_KEY )
        loadUserLoginData()
    }
    
    static func loadUserLoginData()
    {
        userData = UserDefaults.standard.value( forKey: USER_SAVED_DATA_KEY ) as? NSDictionary
    }
    
    static func tryToLoadUserLoginData()
    {
        self.loadUserLoginData()
        if userData != nil, let id = userData?["id"] as? String
        {
            if !id.isEmpty
            {
                DispatchQueue.main.asyncAfter( deadline: .now() + 0.5 ) { sceneDelegate.goToTabBarController() }
            }
        }
    }
    
    static func clear()
    {
        UserDefaults.standard.removeObject( forKey: USER_SAVED_DATA_KEY )
        UserDefaults.standard.synchronize()
    }
}
