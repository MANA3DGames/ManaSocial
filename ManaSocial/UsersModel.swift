//
//  UsersModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation

class UsersModel
{
    public func searchUsers( keyword: String, id: String, onComplete: ( ( [AnyObject] ) -> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: ServerAccess.Operation ) in
            let jsonData = json as? [String: Any]
            if jsonData?["status"] as! String == "200"
            {
                onComplete!( jsonData?["users"] as! [AnyObject] )
            }
            ServerResponseHandler.onCompleteAction( json, operation )
        }
        
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "searchUsers.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "keyword=\(keyword)&id=\(id)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.NONE
        )
    }
}
