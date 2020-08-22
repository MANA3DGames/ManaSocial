//
//  HomeBaseModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class HomeBaseModel
{
    func downloadPosts( id: String, onComplete: ( ( [AnyObject] )-> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: ServerAccess.Operation ) in
            let jsonData = json as? [String: Any]
            onComplete!( jsonData?["posts"] as! [AnyObject] )
            ServerResponseHandler.onCompleteAction( json, operation )
        }
        
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "post.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "id=\(id)&text=&uuid=" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.NONE
        )
    }
    
    // Downloads image data from given 'link' and place in the given 'view'.
    func downloadImg( link: String, view: UIImageView )
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
}
