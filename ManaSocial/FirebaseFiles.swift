import Foundation
import FirebaseStorage

class FirebaseFiles
{
    init() {}

    func uploadImage( path: String, image: UIImage, onComplete: ( (_ imgRef: StorageReference )-> Void )?, onFailed: ( (_ error: String )-> Void )? )
    {
        let imageData = image.jpegData( compressionQuality: 0.5 )
        if imageData == nil
        {
            return
        }

        // Create a root reference
        let storageRef = Storage.storage().reference()

        // Create a reference to the file you want to upload
        let imgRef = storageRef.child( path )

        // Upload the file to the target path
        imgRef.putData( imageData!, metadata: nil ) { ( metadata, error ) in
            
            // Check if there is any error.
            if error != nil
            {
                onFailed?( error.debugDescription )
            }
            else
            {
                // Image has been uploaded successfully.
                onComplete?( imgRef )
            }
        }
    }
    
    func uploadPostImage( userUid: String, imgUid: String, image: UIImage, onComplete: @escaping (_ url : String )-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        uploadImage(
            path: "\(FirebaseFileFields.posts)/\(userUid)/\(imgUid).jpg",
            image: image,
            onComplete: { ( imgRef )  in
                // You can also access to download URL after upload.
                imgRef.downloadURL { ( url, error ) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                    
                    // Update user information with a new photo url.
                    onComplete( downloadURL.absoluteString )
                }
            },
            onFailed: { ( error ) in onFailed( error ) } )
    }
    
    func uploadAvaImage( uid: String, image: UIImage )
    {
        uploadImage( path: "\(FirebaseFileFields.avaImages)/\(uid).jpg", image: image, onComplete: { imgRef in
            FirebaseUser.Instance.profileImage = image
        }, onFailed: nil )
    }
    
    static func downloadImage( path: String, onComplete: ((_ image: UIImage? )-> Void)?, onFailed: ( (_ error: String )-> Void )? )
    {
        // Create a root reference
        let storageRef = Storage.storage().reference()

        // Create a reference to the file you want to download
        let imgRef = storageRef.child( path )
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imgRef.getData( maxSize: 1 * 1024 * 1024 ) { data, error in
          if let error = error
          {
            onFailed?( "Failed to download user profile image: \(error.localizedDescription)" )
          }
          else
          {
            let image = UIImage( data: data! )
            onComplete!( image )
          }
        }
    }
    
    static func downloadAvaImg( userID: String, onComplete: ((_ image: UIImage? )-> Void)?, onFailed: ( (_ error: String )-> Void )? )
    {
        downloadImage(
            path: "\(FirebaseFileFields.avaImages)/\(userID).jpg",
            onComplete: { ( image ) in onComplete!( image ) },
            onFailed: { ( error ) in
                if onFailed != nil
                {
                    onFailed!( "Failed to download user profile image: \(error)" )
                }
        } )
    }

    func deletePostImage( userUid: String, imgUid: String, onComplete: @escaping ()-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        // Create a root reference
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file to delete
        let imgRef = storageRef.child( "\(FirebaseFileFields.posts)/\(userUid)/\(imgUid).jpg" );

        // Delete the file
        imgRef.delete { error in
          if let error = error {
            onFailed( error.localizedDescription )
          } else {
            onComplete()
          }
        }
    }
}
