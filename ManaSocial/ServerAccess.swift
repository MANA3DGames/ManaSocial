//
//  ServerAccess.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/10/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation



struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Response: Codable {
    var results: [Result]
}


class ServerAccess
{
    public static func registerNewUser( email : String, password : String, firstName : String, lastName : String )
    {
        // Create a url to register.php file.
        let url = URL( string: "http://192.168.64.2/manasocial/register.php" )!
        
        // Create a request to get this file.
        var request = URLRequest( url: url )
        // Method to pass data to this file (e.g. via POST)
        request.httpMethod = "POST"
        // Body to be appended to the url.
        let body = "email=\(email)&password=\(password)&firstname=\(firstName)&lastname=\(lastName)"
        request.httpBody = body.data( using: String.Encoding.utf8 )
        
        // execute the datatask and validate the result
        URLSession.shared.dataTask( with: request )
        {
            (data, response, error) in
            if error == nil, let userObject = ( try? JSONSerialization.jsonObject( with: data!, options: [] ) )
            {
                // you've got the jsonObject
                print( userObject )
            }
        }.resume()
    }
    
    public static func loginUser( email: String, password: String )
    {
        // Create a url to login.php file.
        let url = URL( string: "http://192.168.64.2/manasocial/login.php" )!
        
        // Create a request to get the file.
        var request = URLRequest( url: url )
        request.httpMethod = "POST"
        let body =  "email=\(email)&password=\(password)"
        request.httpBody = body.data( using: String.Encoding.utf8 )
        
        // Execute the datatask and validate the result.
        URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in
            if error == nil, let userObject = ( try? JSONSerialization.jsonObject( with: data!, options: [] ) )
            {
                // Everything went successfully!
                print( userObject )
            }
        }.resume()
    }
}
