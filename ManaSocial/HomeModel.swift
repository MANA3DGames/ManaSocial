//
//  HomeModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class HomeModel : HomeBaseModel
{
    /// Deprecated: Please use Firestore func instead of this one.
    func deletePostPHP( uuid: String, path: String, onComplete: ( ()-> Void )? )
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
    
    /// Deprecated: user Firebase func uploadAvaImage()
    public func uploadAvaImagePHP( id: String, image: UIImage )
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
    
    
    func deletePost( sender: HomeVC, forRowAt indexPath: IndexPath )
    {
        sender.showProgressBG()
        
        let post = sender.postsArray[indexPath.row]
        
        // Send php delete request.
        FirebaseUser.Instance.deletePost( postId: post.documentID, imgUrl: post.get( "imgUrl" ) as! String, onComplete: {
            DispatchQueue.main.async {
                sender.postsArray.remove( at: indexPath.row )
                sender.postImagesArray.remove( at: indexPath.row )
                sender.tableView.deleteRows( at: [indexPath], with: UITableView.RowAnimation.automatic )
                
                sender.hideProgressBG()
            }
        }, onFailed: { error in
            MPopup.display( message: error, bgColor: MCOLOR_RED, onComplete: sender.hideProgressBG )
        } )
    }
    
    override func fillUserInfo( sender: HomeBaseViewController, name: String, uid: String )
    {
        super.fillUserInfo( sender: sender, name: name, uid: uid )
        
        sender.emailLabel.text = FirebaseUser.Instance.email
        sender.editProfileBtn.setTitleColor( MCOLOR_BLACK, for: .normal )
    }
}
