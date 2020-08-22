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
    
    enum Operation
    {
        case NONE
        case LOGIN
        case REGISTER
        case RESET_PASSWORD
        case UPDATE_PROFILE_INFO
        case UPLOAD_AVA_IMG
        case UPLOAD_POST
    }
    
    
    
    // Creates a URLRequest using string 'body'
    public static func createURLRequest( url: URL, method: HttpMethod, body: String ) -> URLRequest
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body.data( using: String.Encoding.utf8 )
        return request
    }
    
    // Creates a URLRequest using data 'body'
    public static func createURLRequest( url: URL, method: HttpMethod, body: Data ) -> URLRequest
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    // Executes a datatask session with URLRequest.
    public static func executeDataTask( request: URLRequest, onCompleteAction: ( (_ json: Any,_ operation: Operation) -> Void )?, onFailedAction: ( (_ errorData: Error ) -> Void )?, operation: Operation )
    {
        let task = URLSession.shared.dataTask( with: request )
        {
            ( data, response, error ) in

            if let data = data
            {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject( with: data, options: [] ) as? [String : Any]

                    if let json = jsonSerialized
                    {
                        onCompleteAction?( json, operation )
                    }
                }
                catch let error as NSError
                {
                    onFailedAction?( error )
                }
            }
            else if let error = error
            {
                onFailedAction?( error )
            }
        }

        task.resume()
    }

    
    // Generate a custom body for HTTP request to upload image file.
    public static func createHttpBodyWithParamsToUploadImg( parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String ) -> NSData
    {
        let body = NSMutableData()
        
        if parameters != nil
        {
            for ( key, value ) in parameters!
            {
                body.appendString( "--\(boundary)\r\n" )
                body.appendString( "Content-Disposition: from-data; name=\"\(key)\"\r\n\r\n" )
                body.appendString( "\(value)\r\n" )
            }
        }
        
        let mimetype = "image/jpg"
        
        body.appendString( "--\(boundary)\r\n" )
        body.appendString( "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n" )
        body.appendString( "Content-Type: \(mimetype)\r\n\r\n" )
        body.append( imageDataKey as Data )
        body.appendString( "\r\n" )
        body.appendString( "--\(boundary)--\r\n" )
        
        return body
    }
}

// An extesion o NSMutableData class to append string to out http body.
extension NSMutableData
{
    // Appends given 'string' to current instance.
    func appendString(_ string: String )
    {
        let data = string.data( using: String.Encoding.utf8, allowLossyConversion: true )
        append( data! )
    }
}
