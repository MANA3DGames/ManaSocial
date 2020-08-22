//
//  HomeModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class HomeModel : HomeBaseModel
{
    public override func downloadPosts( id: String, onComplete: ( ( [AnyObject] )-> Void )? )
    {
        super.downloadPosts( id: id, onComplete: onComplete )
    }
    
    public func deletePost( uuid: String, path: String, onComplete: ( ()-> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: ServerAccess.Operation ) in
            let jsonData = json as? [String: Any]
            
            // Check if we have any row was affected by the sql delete.
            if jsonData?["result"] != nil
            {
                onComplete!()
            }
            
            ServerResponseHandler.onCompleteAction( json, operation )
        }
        
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "post.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "uuid=\(uuid)&path=\(path)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.NONE
        )
    }
    
    public func uploadAvaImage( id: String, image: UIImage )
    {
        let param = ["id": id]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let imageData = image.jpegData( compressionQuality: 0.5 )
        if imageData == nil
        {
            return
        }
        let body = ServerAccess.createHttpBodyWithParamsToUploadImg(
            parameters: param,
            filePathKey: "file",
            imageDataKey: imageData! as NSData,
            boundary: boundary,
            filename: "ava.jpg" ) as Data
        
        var request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "uploadAva.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: body )
        request.setValue( "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: ServerResponseHandler.onCompleteAction,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.UPLOAD_AVA_IMG
        )
    }
}
