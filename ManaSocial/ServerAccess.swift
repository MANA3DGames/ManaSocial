//
//  ServerAccess.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/10/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation


class ServerAccess
{
    enum HttpMethod: String
    {
        case GET = "GET"
        case POST = "POST"
    }
    
    private static func executeDataTask( url: URL, method: HttpMethod, body: String, onCompleteAction: ((_ json: Any) -> Void)?, onFailedAction: (() -> Void)? )
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body.data( using: String.Encoding.utf8 )
        
        URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            if error == nil, let userObject = ( try? JSONSerialization.jsonObject( with: data!, options: [] ) )
            {
                onCompleteAction?( userObject )
            }
            else
            {
                onFailedAction?()
            }
        }.resume()
    }
    
    
    public static func registerUser( email : String, password : String, firstName : String, lastName : String )
    {
        let onCompleteAction = { ( data: Any ) in
            print( data )
        }
        
        let onFailedAction = {
            print( "Session failed." )
        }
        
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/register.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)&firstname=\(firstName)&lastname=\(lastName)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction )
    }
    
    public static func loginUser( email: String, password: String )
    {
        let onCompleteAction = { ( data: Any ) in print( data ) }
        
        let onFailedAction = { print( "Session faild" ) }
        
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/login.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction )
    }
    
    public static func resetUserPassword( email: String )
    {
        let onCompleteAction = { ( data: Any ) in print( data ) }
        let onFailedAction = { print( "Session faild" ) }
        
        executeDataTask(
            url: URL( string: "http://192.168.64.2/manasocial/resetpassword.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)",
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction )
    }
}
