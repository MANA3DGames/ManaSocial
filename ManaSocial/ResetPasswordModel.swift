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
    /// Deprecated: please use Firebase func istead of this one.
    func resetPasswordPHP( email: String )
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
    
    func resetPassword(_ email: String, sender: ResetPasswordVC )
    {
        sender.showProgressBG()
        
        FirebaseUser.Instance.resetPassword(
            email: email,
            onComplete: {
                MPopup.display( message: "Please check your email to reset your password", bgColor: MCOLOR_GREEN, onComplete: nil )
                sender.hideProgressBG()
            },
            onFailed: { error in
                MPopup.display( message: error, bgColor: MCOLOR_RED, onComplete: nil )
                sender.hideProgressBG()
        } )
    }
}
