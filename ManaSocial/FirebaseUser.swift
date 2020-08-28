//
//  FirebaseUser.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/24/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseUser
{
    private static var _instance : FirebaseUser?
    
    static var Instance : FirebaseUser {
        get {
            if _instance == nil
            {
                _instance = FirebaseUser()
            }
            
            return _instance!
        }
    }
    
    let fbDatabase = FirestoreDatabase()
    let fbFiles = FirebaseFiles()
    
    private var _tempPass: String?
    var tempPass: String {
        get {
            return _tempPass!
        }
        set {
            _tempPass = newValue
        }
    }
    
    private var fbUser : User?
    
    var isInitialized : Bool {
        get {
            return fbUser != nil
        }
    }
    
    var isEmailVerified : Bool {
        get {
            return isInitialized && fbUser!.isEmailVerified
        }
    }
    
    var uid : String {
        get {
            return fbUser!.uid
        }
    }
    
    var email : String {
        get {
            return fbUser!.email!
        }
    }
    
    var displayName : String {
        get {
            return fbDatabase.displayName
        }
    }
    
    
    private init() {
        
    }
    
    func initilaize(_ user: User )
    {
        fbUser = user
        fbDatabase.loadUserDoc( userId: fbUser!.uid, onComplete: nil )
    }
    
   
    func addUserDoc()
    {
        fbDatabase.addUserDoc( userId: uid, displayName: generateDefaultDisplayName() )
    }
    
    func sendEmailVerification( onComplete: ( ()-> Void )? )
    {
        if !isEmailVerified
        {
            fbUser!.sendEmailVerification( completion: { ( error ) in
              
                // Check if there is any error?
                if error != nil
                {
                    print( error.debugDescription )
                    onComplete?()
                }
                // Verification email has been sent successfully.
                else
                {
                  // Notify the user about the verification email.
                  MPopup.display( message: "A verification email has been sent to your email address", bgColor: MCOLOR_GREEN ) {
                     onComplete?()
                  }
                }
            } )
        }
    }
    
    func updateEmail( email: String, onComplete: ( ()-> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        fbUser?.updateEmail( to: email, completion: { ( error ) in
            // Check for error
            if error != nil
            {
                onFailed?( String( error!.localizedDescription ) )
            }
            else
            {
                onComplete?()
            }
        } )
    }
    
    func updateDisplayName( name: String, onComplete: ( ()-> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        fbDatabase.updateDisplayName( userId: uid, name: name, onComplete: onComplete, onFailed: onFailed )
    }
    
    func generateDefaultDisplayName() -> String
    {
        // Get current user's email.
        let email = fbUser?.email
        // Get first part of the email address and use it as a user name.
        let displayName = String( email![..<email!.firstIndex( of: "@" )!] )
        
        return displayName
    }
    
    func uploadAvaImage(_ image: UIImage )
    {
        fbFiles.uploadAvaImage( uid: uid, image: image )
    }
    
    func searchForUsers( keyword: String, onComplete: ( ( [AnyObject] ) -> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        fbDatabase.searchForUsers( keyword: keyword, id: uid, onComplete: onComplete, onFailed: onFailed )
    }
}
