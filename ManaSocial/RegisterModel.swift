//
//  RegisterModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseAuth

class RegisterModel
{
    /// Deprecated: use Firebase func --> register( email, password )
    public func registerPHP( email : String, password : String, firstName : String, lastName : String )
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
    
    public func register( email: String, password: String, sender: RegisterVC )
    {
        sender.showProgressBG()
        
        let onComplete = {
            self.onCompleteAction( sender )
            
            // Create a new document for this user in the users collection.
            FirebaseUser.Instance.addUserDoc()
        }
        createUser( email: email, password: password, onComplete: onComplete, onFailed: sender.hideProgressBG )
    }
    
    private func createUser( email: String, password: String, onComplete: (()-> Void)!, onFailed: (()-> Void)! )
    {
        Auth.auth().createUser( withEmail: email, password: password ) { ( authDataResult, error ) in
            
            // Check if user was created successfully?
            if authDataResult != nil
            {
                // initialize our Firebase user with the returned user.
                FirebaseUser.Instance.initilaize( authDataResult!.user )
                
                // Send a verification email to the user's email address.
                FirebaseUser.Instance.sendEmailVerification( onComplete: onComplete )
            }
            else if ( error != nil )
            {
                let msg = error?.localizedDescription ?? ""
                MPopup.display( message: msg, bgColor: MCOLOR_RED, onComplete: nil )

                onFailed()
            }
       }
    }
    
    public func resendEmailVerfication(_ sender: RegisterVC )
    {
        let onComplete = { self.onCompleteAction( sender ) }
        FirebaseUser.Instance.sendEmailVerification( onComplete: onComplete )
    }
    
    func onCompleteAction(_ sender: RegisterVC )
    {
        sender.showRegistrationUI( false )
        sender.showVerificationUI( true )
        sender.hideProgressBG()

        // Check if we don't have a password (cause we may have come from Login-view to verify email address)
        var pass = sender.passwordTxt.text!
        if pass.isEmpty
        {
            pass = FirebaseUser.Instance.tempPass
        }
        
        Timer.scheduledTimer( withTimeInterval: 5, repeats: true ) { ( timer ) in
            
            Auth.auth().signIn( withEmail: FirebaseUser.Instance.email, password: pass ) { ( authDataResult, error ) in
                
                if authDataResult != nil
                {
                    FirebaseUser.Instance.initilaize( authDataResult!.user )
                    if FirebaseUser.Instance.isEmailVerified
                    {
                        timer.invalidate()
                        
                        sceneDelegate.goToTabBarController()
                        //sender.moveToViewController( from: sender, toID: ID_TAB_BAR )
                        sender.showRegistrationUI( true )
                        sender.showVerificationUI( false )
                    }
                }
            }
        }
    }
}
