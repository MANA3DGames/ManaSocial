import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreDatabase
{
    var db : Firestore?
    var usersCollectionRef : CollectionReference? = nil
    var userDocRef : DocumentSnapshot? = nil
    
    var displayName : String {
        get {
            if userDocRef != nil
            {
                return userDocRef?.get( FirestoreFields.User.name ) as! String
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
        usersCollectionRef = db?.collection( FirestoreFields.users )
    }

    func loadUserDoc( userId: String, onComplete: ( ()-> Void )? )
    {
        usersCollectionRef?.document( userId ).getDocument( completion: { ( documentSnapshot, error ) in
            if error == nil && documentSnapshot != nil
            {
                self.userDocRef = documentSnapshot
                onComplete?()
            }
        } )
    }
    
    func addUserDoc( userId: String, displayName: String )
    {
        usersCollectionRef?.document( userId ).setData( [
            FirestoreFields.User.name : displayName,
            FirestoreFields.User.date : Date()
        ], completion: { ( error ) in
            if error == nil
            {
                self.loadUserDoc( userId: userId, onComplete: nil )
            }
        } )
    }
    
    func updateDisplayName( userId: String, name: String, onComplete: ( ()-> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        usersCollectionRef?.document( userId ).updateData( [
            FirestoreFields.User.name : name
        ], completion: { ( error ) in
            if error == nil
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
        usersCollectionRef?.document( userId ).collection( FirestoreFields.User.posts ).document( postId ).setData( [
            FirestoreFields.User.Post.text : text,
            FirestoreFields.User.Post.imgUrl : imgUrl,
            FirestoreFields.User.Post.poster : FirebaseUser.Instance.displayName
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
        usersCollectionRef?.document( userId ).collection( FirestoreFields.User.posts ).document( docId ).delete() { error in
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
    
    func downloadPosts( userId: String, onComplete: @escaping ( [DocumentSnapshot]  )-> Void, onFailed: @escaping (_ error : String )-> Void )
    {
        usersCollectionRef?.document( userId ).collection( FirestoreFields.User.posts ).getDocuments( completion: { ( querySnapshot, error ) in
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
                .whereField( FirestoreFields.User.name, isGreaterThanOrEqualTo: keyword )
                .whereField( FirestoreFields.User.name, isLessThanOrEqualTo: keyword + "\u{f8ff}" )
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
    
    func getRandomUsers( onComplete: ( ( [AnyObject] ) -> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        usersCollectionRef?.getDocuments( completion: { ( querySnapshot, error ) in
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
