//
//  PostModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class PostModel
{
    /// Deprecated : Please use Firebase func instead of this one.
    func uploadPostPHP( id: String, text: String, didPickupImage: Bool, imageView: UIImageView, onComplete: (()-> Void)? )
    {
        // Create a new custom action to combine given 'onComplete' action with generic 'onCompleteAction'
        let customOnCompleteAction = { (_ json: Any, operation: ServerAccess.Operation  ) in
           onComplete!()
           ServerResponseHandler.onCompleteAction( json, operation )
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

        let body = ServerAccess.createHttpBodyWithParamsToUploadImg(
           parameters: param,
           filePathKey: "file",
           imageDataKey: imageData,
           boundary: boundary,
           filename: filename ) as Data

        var request = ServerAccess.createURLRequest(
           url: URL( string: ServerData.baseURL + "post.php" )!,
           method: ServerAccess.HttpMethod.POST,
           body: body )
        request.setValue( "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type" )

        ServerAccess.executeDataTask(
           request: request,
           onCompleteAction: customOnCompleteAction,
           onFailedAction: ServerResponseHandler.onFailedAction,
           operation: ServerAccess.Operation.UPLOAD_POST
        )
    }
    
    func uploadPost( id: String, text: String, didPickupImage: Bool, imageView: UIImageView, onComplete: (()-> Void)? )
    {
        MPopup.display(
            message: "Firestore UploadPost func has not been implemented yet, please check out uploadPostPHP()",
            bgColor: MCOLOR_RED,
            onComplete: nil )
    }
}
