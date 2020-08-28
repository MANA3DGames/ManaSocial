//
//  LoginModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginModel
{
    /// Deprecated: use Firebase func login( email, password )
    public func loginPHP( email: String, password: String )
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
    
    public func login( email: String, password: String, sender: LoginVC )
    {
        sender.showProgressBG()
        
        Auth.auth().signIn( withEmail: email, password: password ) { ( authDataResult, error ) in
            
            if authDataResult != nil
            {
                // Update firebase user.
                FirebaseUser.Instance.initilaize( authDataResult!.user )
                
                // Check if current user email is not verified.
                if !FirebaseUser.Instance.isEmailVerified
                {
                    print( "User's email address has not been verified yet." )
                    // Save user password.
                    FirebaseUser.Instance.tempPass = password
                    // Go to register view controller then display verification view.
                    sender.moveToViewController( from: sender, toID: ID_REGISTER_VC )
                }
                // User's email address was verified successfully.
                else
                {
                    // Notify user about signing in.
                    MPopup.display( message: "User has been signed in successffully", bgColor: MCOLOR_GREEN, onComplete: {
                        sceneDelegate.goToTabBarController()
                        sender.hideProgressBG()
                    } )
                }
            }
            else if error != nil
            {
                let msg = error?.localizedDescription ?? ""
                MPopup.display( message: msg, bgColor: MCOLOR_RED, onComplete: nil )
                sender.hideProgressBG()
            }
        }
    }
}
