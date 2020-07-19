//
//  ServerAccess.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/10/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit


class ServerAccess
{
    enum HttpMethod: String
    {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum Operation
    {
        case LOGIN
        case REGISTER
        case RESET_PASSWORD
    }
    
    static let onCompleteAction = { ( jsonData: Any, operation: Operation ) in
        print( jsonData )
        
        let json = jsonData as? [String: Any]
        let status = json?["status"] as? String
        
        var bgColor : UIColor
        if status != "200"
        {
            bgColor = redColorError
        }
        else
        {
            bgColor = greenColorDone
        }
        
        // Get main queue to communicate back to user.
        DispatchQueue.main.async {
            let message = json?["message"] as? String
            sceneDelegate.displayPopup( message: message!, bgColor: bgColor )
            
            // Check if successed.
            if status == "200"
            {
                switch operation
                {
                case Operation.LOGIN:
                    sceneDelegate.saveUserData( json! )
                    sceneDelegate.goToTabBarController()
                case Operation.REGISTER:
                    sceneDelegate.saveUserData( json! )
                    print( "Register" )
                case Operation.RESET_PASSWORD:
                    print( "Reset Password" )
                }
            }
        }
    }

    static let onFailedAction = { ( error : Error ) in
        print( error )
        
        // Get main queue to communicate back to user.
        DispatchQueue.main.async {
            sceneDelegate.displayPopup( message: error.localizedDescription, bgColor: redColorError )
        }
    }
    

    
    private static func executeDataTask( url: URL, method: HttpMethod, body: String, onCompleteAction: ( (_ json: Any,_ operation: Operation) -> Void )?, onFailedAction: ( (_ errorData: Error ) -> Void )?, operation: Operation )
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body.data( using: String.Encoding.utf8 )
        
        URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            if error == nil, let userObject = ( try? JSONSerialization.jsonObject( with: data!, options: [] ) )
            {
                onCompleteAction?( userObject, operation )
            }
            else
            {
                onFailedAction?( error! )
            }
        }.resume()
    }
    
    
    
    public static func registerUser( email : String, password : String, firstName : String, lastName : String )
    {
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/register.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)&firstname=\(firstName)&lastname=\(lastName)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.REGISTER
        )
    }
    
    public static func loginUser( email: String, password: String )
    {
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/login.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.LOGIN
        )
    }
    
    public static func resetUserPassword( email: String )
    {
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/resetpassword.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.RESET_PASSWORD
        )
    }
}
