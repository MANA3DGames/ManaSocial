//
//  HomeBaseModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class HomeBaseModel
{
    func fillUserInfo( sender: HomeBaseViewController, name: String, uid: String )
    {
        // Fill user's details.
        sender.fullNameLabel.text = name

        // Download profile image using 'FirebaseUser photoURL' link.
        FirebaseFiles.downloadAvaImg( userID: uid, onComplete: { ( image ) in
            // Check if we have download an image.
            if image != nil
            {
                sender.avaImg.image = image
            }
        }, onFailed: nil )
        
        
        // Rounded Corners.
        sender.avaImg.layer.cornerRadius = sender.avaImg.bounds.width / 20
        sender.avaImg.clipsToBounds = true
        
        // Set current navigation title to current user name.
        sender.navigationItem.title = sender.fullNameLabel.text
    }
    
    /// Deprecated: please use Firebase func instead of this one
    func downloadPostsPHP( id: String, onComplete: ( ( [AnyObject] )-> Void )? )
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
    
    func downloadPosts( userID: String, onComplete: @escaping ( [DocumentSnapshot] )-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        FirebaseUser.Instance.downloadPosts( userID: userID, onComplete: onComplete, onFailed: onFailed )
    }
    
    /// Deprecated:  instead please use Firebase func.
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
    
    /// Downloads image data from given 'link' and place in the given 'view'.
    func downloadImg( url: URL, view: UIImageView )
    {
        // Get main queue.
        DispatchQueue.main.async {
            // Get image data from the given url.
            let imgData = try? Data( contentsOf: url )
            
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
