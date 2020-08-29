//
//  FirestoreDatabase.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/26/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreDatabase
{
    var db : Firestore?
    var usersCollectionRef : CollectionReference? = nil
    //var userDocRef : DocumentReference? = nil
    var userDocRef : DocumentSnapshot? = nil
    
    var displayName : String {
        get {
            if userDocRef != nil
            {
                return userDocRef?.get( "name" ) as! String
            }
            else
            {
                return ""
            }
        }
    }
    
    
    init()
    {
        db = Firestore.firestore()
        usersCollectionRef = db?.collection( "users" )
    }
    
    
    func loadUserDoc( userId: String, onComplete: ( ()-> Void )? )
    {
        usersCollectionRef?.document( userId ).getDocument( completion: { ( documentSnapshot, error ) in
            if error != nil
            {
                print( "Failed to download user doc due to \( error.debugDescription )" )
            }
            else if documentSnapshot != nil
            {
                self.userDocRef = documentSnapshot
                onComplete?()
            }
        } )
    }
    
    func addUserDoc( userId: String, displayName: String )
    {
        usersCollectionRef?.document( userId ).setData( [
            "name" : displayName,
            "date" : Date()
        ], completion: { ( error ) in
            if error != nil
            {
                print( "Failed to add user doc due to \(error.debugDescription)" )
            }
            else
            {
                self.loadUserDoc( userId: userId, onComplete: nil )
            }
        } )
    }
    
    func updateDisplayName( userId: String, name: String, onComplete: ( ()-> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        usersCollectionRef?.document( userId ).updateData( [
            "name" : name
        ], completion: { ( error ) in
            if error != nil
            {
                onFailed?( String( error!.localizedDescription ) )
            }
            else
            {
                self.loadUserDoc( userId: userId, onComplete: onComplete )
            }
        } )
    }
    
    func addPostDoc( userId: String, postId: String, text: String, imgUrl: String, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error : String )-> Void )
    {
        usersCollectionRef?.document( userId ).collection( "Posts" ).document( postId ).setData( [
            "text" : text,
            "imgUrl" : imgUrl,
            "poster" : FirebaseUser.Instance.displayName
        ], completion: { ( error ) in
            if error != nil
            {
                onFailed( "Failed to add user doc due to \(error.debugDescription)" )
            }
            else
            {
                onComplete()
            }
        } )
    }
    
    func deletePostDoc( userId: String, docId: String, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error: String )-> Void  )
    {
        usersCollectionRef?.document( userId ).collection( "Posts" ).document( docId ).delete() { error in
            if error != nil
            {
                onFailed( error!.localizedDescription )
                print( "Failed to delete post." )
            }
            else
            {
                onComplete()
                print( "Post was deleted." )
            }
        }
    }
    
    func downloadPosts( userId: String, onComplete: @escaping ( [DocumentSnapshot]  )-> Void, onFailed: @escaping (_ error : String )-> Void )
    {
        usersCollectionRef?.document( userId ).collection( "Posts" ).getDocuments( completion: { ( querySnapshot, error ) in
            if error != nil
            {
                onFailed( error!.localizedDescription )
            }
            else if querySnapshot != nil
            {
                onComplete( querySnapshot!.documents )
            }
        } )
    }
    
    func searchForUsers( keyword: String, id: String, onComplete: ( ( [AnyObject] ) -> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        if !keyword.isEmpty
        {
            usersCollectionRef?
                .whereField( "name", isGreaterThanOrEqualTo: keyword )
                .whereField( "name", isLessThanOrEqualTo: keyword + "\u{f8ff}" )
                .getDocuments( completion: { ( querySnapshot, error ) in
                if error != nil
                {
                    onFailed?( error!.localizedDescription )
                }
                else if querySnapshot != nil
                {
                    onComplete?( querySnapshot!.documents )
                }
            } )
        }
    }
    
}
