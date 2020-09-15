import Foundation
import UIKit
import FirebaseFirestore

class HomeBaseModel
{
    func fillUserInfo( sender: HomeBaseViewController, name: String, uid: String )
    {
        // Fill user's details.
        sender.fullNameLabel.text = name

        let isCurrentUser = sender is HomeVC
        
        // Check if this is the current user and we already have a profile image.
        if ( isCurrentUser && FirebaseUser.Instance.profileImage != nil )
        {
            sender.avaImg.image = FirebaseUser.Instance.profileImage
        }
        else
        {
            // Download profile image using 'FirebaseUser photoURL' link.
            FirebaseFiles.downloadAvaImg( userID: uid, onComplete: { ( image ) in
                // Check if we have download an image.
                if image != nil
                {
                    // Check if this is the current user.
                    if isCurrentUser
                    {
                        // Save user profile.
                        FirebaseUser.Instance.profileImage = image
                    }
                    
                    sender.avaImg.image = image
                }
            }, onFailed: nil )
        }
        
        // Rounded Corners.
        sender.avaImg.layer.cornerRadius = sender.avaImg.bounds.width / 20
        sender.avaImg.clipsToBounds = true
        
        // Set current navigation title to current user name.
        sender.navigationItem.title = sender.fullNameLabel.text
    }
    
    func downloadPosts( userID: String, onComplete: @escaping ( [DocumentSnapshot] )-> Void, onFailed: @escaping (_ error: String )-> Void )
    {
        FirebaseUser.Instance.downloadPosts( userID: userID, onComplete: onComplete, onFailed: onFailed )
    }
    
    /// Downloads image data from given 'link' and place in the given 'view'.
    func downloadImg( url: URL, view: UIImageView )
    {
        // Get main queue.
        DispatchQueue.main.async {
            // Get image data from the given url.
            let imgData = try? Data( contentsOf: url )
            
            // Make sure we have some data.
            if imgData != nil
            {
                DispatchQueue.main.async {
                    // Create a UIImage from the downloaded image data and set it as image for the given 'view'
                    view.image = UIImage( data: imgData! )
                }
            }
        }
    }
}
