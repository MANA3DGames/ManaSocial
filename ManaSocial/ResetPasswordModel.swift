//
//  ResetPasswordModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation


class ResetPasswordModel
{
    public func resetPassword( email: String )
    {
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "resetpassword.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "email=\(email)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: ServerResponseHandler.onCompleteAction,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.RESET_PASSWORD
        )
    }
}
