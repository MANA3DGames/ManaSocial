//
//  FirebaseUser.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/24/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
    
    
    func signout()
    {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }

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
    
    func resetPassword( email : String, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        Auth.auth().sendPasswordReset( withEmail: email) { ( error ) in
            if error != nil
            {
                onFailed( error!.localizedDescription )
            }
            else
            {
                onComplete()
            }
        }
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
    
    func uploadPost( text: String, image: UIImage?, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        // Create a uniqe id for this post (current date) for this user
        var postID = Date().description
        postID = String( postID[..<postID.firstIndex( of: "+" )!] )
        
        if image != nil
        {
            fbFiles.uploadPostImage( userUid: uid, imgUid: postID, image: image!, onComplete: { ( url ) in
                self.fbDatabase.addPostDoc( userId: self.uid, postId: postID, text: text, imgUrl: url, onComplete: onComplete, onFailed: onFailed )
            }, onFailed: onFailed )
        }
        else
        {
            fbDatabase.addPostDoc( userId: uid, postId: postID, text: text, imgUrl: "", onComplete: onComplete, onFailed: onFailed )
        }
    }
    
    func downloadPosts( userID: String, onComplete: @escaping ( [DocumentSnapshot] )-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        fbDatabase.downloadPosts( userId: userID, onComplete: onComplete, onFailed: onFailed )
    }
    
    func deletePost( postId: String, imgUrl: String, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        let customOnComplete = {
            if !imgUrl.isEmpty
            {
                self.fbFiles.deletePostImage( userUid: self.uid, imgUid: postId, onComplete: onComplete, onFailed: onFailed )
            }
            else
            {
                onComplete()
            }
        }
        
        fbDatabase.deletePostDoc( userId: uid, docId: postId, onComplete: customOnComplete, onFailed: onFailed )
    }
}
