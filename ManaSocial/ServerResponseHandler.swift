//
//  ResponseHandler.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class ServerResponseHandler
{
    static let onCompleteAction = { ( jsonData: Any, operation: ServerAccess.Operation ) in
        //print( jsonData )
        
        let json = jsonData as? [String: Any]
        let status = json?["status"] as? String
        
        var bgColor : UIColor
        if status != "200"
        {
            bgColor = MCOLOR_RED
        }
        else
        {
            bgColor = MCOLOR_GREEN
        }
        
        // Get main queue to communicate back to user.
        DispatchQueue.main.async {
            let message = json?["message"] as? String

            // Check if successed.
            if status == "200"
            {
                switch operation
                {
                case .NONE:
                    print( "" )
                case .LOGIN, .REGISTER, .UPDATE_PROFILE_INFO:
                    MPopup.display( message: message!, bgColor: bgColor, onComplete: {
                        sceneDelegate.goToTabBarController()
                    } )
                    UserLocalData.save( json! )
                case .RESET_PASSWORD:
                    MPopup.display( message: message!, bgColor: bgColor, onComplete: nil )
                    print( "Reset Password" )
                case .UPLOAD_AVA_IMG:
                    UserLocalData.save( json! )
                    print( "UPLOAD_AVA_IMG" )
                case .UPLOAD_POST:
                    print( "UPLOAD_POST" )
                }
            }
        }
    }
    
    static let onFailedAction = { ( error : Error ) in
        print( error )
        
        // Get main queue to communicate back to user.
        DispatchQueue.main.async {
            MPopup.display( message: error.localizedDescription, bgColor: MCOLOR_RED, onComplete: nil )
        }
    }
}
