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
        case NONE
        case LOGIN
        case REGISTER
        case RESET_PASSWORD
        case UPDATE_PROFILE_INFO
        case UPLOAD_AVA_IMG
        case UPLOAD_POST
    }
    
    static let onCompleteAction = { ( jsonData: Any, operation: Operation ) in
        //print( jsonData )
        
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

            // Check if successed.
            if status == "200"
            {
                switch operation
                {
                case .NONE:
                    print( "" )
                case .LOGIN, .REGISTER, .UPDATE_PROFILE_INFO:
                    sceneDelegate.displayPopup( message: message!, bgColor: bgColor, onComplete: {
                        sceneDelegate.goToTabBarController()
                    } )
                    sceneDelegate.saveUserData( json! )
                case Operation.RESET_PASSWORD:
                    sceneDelegate.displayPopup( message: message!, bgColor: bgColor, onComplete: nil )
                    print( "Reset Password" )
                case Operation.UPLOAD_AVA_IMG:
                    sceneDelegate.saveUserData( json! )
                    print( "UPLOAD_AVA_IMG" )
                case Operation.UPLOAD_POST:
                    print( "UPLOAD_POST" )
                }
            }
        }
    }

    static let onFailedAction = { ( error : Error ) in
        print( error )
        
        // Get main queue to communicate back to user.
        DispatchQueue.main.async {
            sceneDelegate.displayPopup( message: error.localizedDescription, bgColor: redColorError, onComplete: nil )
        }
    }
    
    static let baseURL = "http://192.168.64.2/manasocial/"
    
    

    // Creates a URLRequest using string 'body'
    private static func createURLRequest( url: URL, method: HttpMethod, body: String ) -> URLRequest
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body.data( using: String.Encoding.utf8 )
        return request
    }
    
    // Creates a URLRequest using data 'body'
    private static func createURLRequest( url: URL, method: HttpMethod, body: Data ) -> URLRequest
    {
        var request = URLRequest( url: url )
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    // Executes a datatask session with URLRequest.
    private static func executeDataTask( request: URLRequest, onCompleteAction: ( (_ json: Any,_ operation: Operation) -> Void )?, onFailedAction: ( (_ errorData: Error ) -> Void )?, operation: Operation )
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
    
    
    
    public static func register( email : String, password : String, firstName : String, lastName : String )
    {
        let request = createURLRequest(
            url: URL( string: baseURL + "register.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)&firstname=\(firstName)&lastname=\(lastName)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.REGISTER
        )
    }
    
    public static func login( email: String, password: String )
    {
        let request = createURLRequest(
            url: URL( string: baseURL + "login.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)&password=\(password)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.LOGIN
        )
    }
    
    public static func resetPassword( email: String )
    {
        let request = createURLRequest(
            url: URL( string: baseURL + "resetpassword.php" )!,
            method: HttpMethod.POST,
            body: "email=\(email)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.RESET_PASSWORD
        )
    }
    
    
    
    public static func uploadAvaImage( id: String, image: UIImage )
    {
        let param = ["id": id]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let imageData = image.jpegData( compressionQuality: 0.5 )
        if imageData == nil
        {
            return
        }
        let body = createHttpBodyWithParamsToUploadImg(
            parameters: param,
            filePathKey: "file",
            imageDataKey: imageData! as NSData,
            boundary: boundary,
            filename: "ava.jpg" ) as Data
        
        var request = createURLRequest(
            url: URL( string: baseURL + "uploadAva.php" )!,
            method: HttpMethod.POST,
            body: body )
        request.setValue( "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type" )
        
        executeDataTask(
            request: request,
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.UPLOAD_AVA_IMG
        )
    }
    
    // Generate a custom body for HTTP request to upload image file.
    private static func createHttpBodyWithParamsToUploadImg( parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String ) -> NSData
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
    
    // Downloads image data from given 'link' and place in the given 'view'.
    public static func downloadImg( link: String, view: UIImageView )
    {
        // Make sure we don't have empty link?
        if !link.isEmpty
        {
            // Create URL to image data.
            let imgURL = URL( string: link )
            
            // Get main queue.
            DispatchQueue.main.async {
                // Get image data from the given url.
                let imgData = try? Data( contentsOf: imgURL! )
                
                // Make sure we have some data.
                if imgData != nil
                {
                    DispatchQueue.main.async {
                        // Create a UIImage from the downloaded image data and set it as image for the given 'view'
                        view.image = UIImage( data: imgData! )
                    }
                }
            }
        }
    }
    
    
    
    public static func uploadPost( id: String, text: String, didPickupImage: Bool, imageView: UIImageView, onComplete: (()-> Void)? )
    {
        // Create a new custom action to combine given 'onComplete' action with generic 'onCompleteAction'
        let customOnCompleteAction = { (_ json: Any, operation: Operation  ) in
            onComplete!()
            onCompleteAction( json, operation )
        }
        
        //text = text.trunc( length: 140 )
        
        // Generate unique id.
        let uuid = NSUUID().uuidString
        
        // If file is not selected then it will not upload any image to the server since we will not declare any filename.
        var imageData = NSData()
        var filename = ""
        if didPickupImage
        {
            filename = "post-\(uuid).jpg"
            imageData = imageView.image!.jpegData( compressionQuality: 0.5 )! as NSData
        }
        
        let param = [
            "id": id,
            "uuid": uuid,
            "text": text
        ]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        let body = createHttpBodyWithParamsToUploadImg(
            parameters: param,
            filePathKey: "file",
            imageDataKey: imageData,
            boundary: boundary,
            filename: filename ) as Data
        
        var request = createURLRequest(
            url: URL( string: baseURL + "post.php" )!,
            method: HttpMethod.POST,
            body: body )
        request.setValue( "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type" )
        
        executeDataTask(
            request: request,
            onCompleteAction: customOnCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.UPLOAD_POST
        )
    }
    
    public static func downloadPosts( id: String, onComplete: ( ( [AnyObject] )-> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: Operation ) in
            let jsonData = json as? [String: Any]
            onComplete!( jsonData?["posts"] as! [AnyObject] )
            onCompleteAction( json, operation )
        }
        
        let request = createURLRequest(
            url: URL( string: baseURL + "post.php" )!,
            method: HttpMethod.POST,
            body: "id=\(id)&text=&uuid=" )
        
        executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: onFailedAction,
            operation: Operation.NONE
        )
    }
    
    public static func deletePost( uuid: String, path: String, onComplete: ( ()-> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: Operation ) in
            let jsonData = json as? [String: Any]
            
            // Check if we have any row was affected by the sql delete.
            if jsonData?["result"] != nil
            {
                onComplete!()
            }
            
            onCompleteAction( json, operation )
        }
        
        let request = createURLRequest(
            url: URL( string: baseURL + "post.php" )!,
            method: HttpMethod.POST,
            body: "uuid=\(uuid)&path=\(path)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: onFailedAction,
            operation: Operation.NONE
        )
    }
    
    
    
    public static func searchUsers( keyword: String, id: String, onComplete: ( ( [AnyObject] ) -> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: Operation ) in
            let jsonData = json as? [String: Any]
            if jsonData?["status"] as! String == "200"
            {
                onComplete!( jsonData?["users"] as! [AnyObject] )
            }
            onCompleteAction( json, operation )
        }
        
        let request = createURLRequest(
            url: URL( string: baseURL + "searchUsers.php" )!,
            method: HttpMethod.POST,
            body: "keyword=\(keyword)&id=\(id)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: onFailedAction,
            operation: Operation.NONE
        )
    }
    
    public static func updateUserProfile( firstName: String, lastName: String, email: String, id: String )
    {
        let request = createURLRequest(
            url: URL( string: baseURL + "updateUser.php" )!,
            method: HttpMethod.POST,
            body: "firstname=\(firstName)&lastname=\(lastName)&email=\(email)&id=\(id)" )
        
        executeDataTask(
            request: request,
            onCompleteAction: onCompleteAction,
            onFailedAction: onFailedAction,
            operation: Operation.UPDATE_PROFILE_INFO
        )
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

//extension String
//{
//    func trunc( length: Int, trailing: String? = "..." ) -> String
//    {
//        if self.count > length
//        {
//            return self.substring( to: self.startIndex.advancedBy( length ) ) + ( trailing ?? "" )
//        }
//        else
//        {
//            return self
//        }
//    }
//}
