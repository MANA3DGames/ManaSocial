//
//  RegisterModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation

class RegisterModel
{
    public func register( email : String, password : String, firstName : String, lastName : String )
    {
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "register.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "email=\(email)&password=\(password)&firstname=\(firstName)&lastname=\(lastName)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: ServerResponseHandler.onCompleteAction,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.REGISTER
        )
    }
}
