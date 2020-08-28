//
//  FirebaseFiles.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/26/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseFiles
{
    init() {
        
    }
    
    func uploadAvaImage( uid: String, image: UIImage )
    {
        let imageData = image.jpegData( compressionQuality: 0.5 )
        if imageData == nil
        {
            return
        }

        // Create a root reference
        let storageRef = Storage.storage().reference()

        // Create a reference to the file you want to upload
        let imgRef = storageRef.child( "avaImages/\(uid).jpg" )

        // Upload the file to the target path
        //let uploadTask =
        imgRef.putData( imageData!, metadata: nil ) { ( metadata, error ) in
            
            // Check if there is any error.
            if error != nil
            {
                print( error.debugDescription )
            }
            else
            {
//                // You can also access to download URL after upload.
//                imgRef.downloadURL { ( url, error ) in
//                    guard let downloadURL = url else {
//                      // Uh-oh, an error occurred!
//                      return
//                    }
//
//                    // Update user information with a new photo url.
//                    self.updateAvaURL( url: downloadURL, onComplete: nil, onFailed: nil )
//                }
                
                print( "Avatar image has been uploaded successfully" )
            }
        }
    }
    
    static func downloadAvaImg( userID: String, onComplete: ((_ image: UIImage? )-> Void)?, onFailed: ( (_ error: String )-> Void )? )
    {
        // Create a root reference
        let storageRef = Storage.storage().reference()

        // Create a reference to the file you want to download
        let imgRef = storageRef.child( "avaImages/\(userID).jpg" )
        
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
    
    
}
