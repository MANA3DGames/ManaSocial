//
//  LoginModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation


class LoginModel
{
    public func login( email: String, password: String )
    {
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "login.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "email=\(email)&password=\(password)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: ServerResponseHandler.onCompleteAction,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.LOGIN
        )
    }
}
