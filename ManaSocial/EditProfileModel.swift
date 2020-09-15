import Foundation
import UIKit

class EditProfileModel
{
    func fillUserInfo(_ sender: EditProfileVC )
    {
        sender.emailTxt.text = FirebaseUser.Instance.email
        sender.displayNameTxt.text = FirebaseUser.Instance.displayName

        if FirebaseUser.Instance.profileImage != nil
        {
            sender.avaImg.image = FirebaseUser.Instance.profileImage
        }
        else
        {
            FirebaseFiles.downloadAvaImg( userID: FirebaseUser.Instance.uid, onComplete: { ( img ) in
                if img != nil
                {
                    sender.avaImg.image = img
                }
            }, onFailed: nil )
        }
    }
    
    func updateUserProfile( displayName: String, email: String, sender: EditProfileVC )
    {
        // Display progress indicator.
        sender.showProgressBG()
        
        let onComplete = {
            MPopup.display( message: "Your profile was updated successfully", bgColor: UIInfo.MCOLOR_GREEN, onComplete: nil )
            sender.hideProgressBG()
        }
        let onFailed = { ( error: String ) in
            MPopup.display( message: "Failed to update profile: \(error)", bgColor: UIInfo.MCOLOR_RED, onComplete: nil )
            sender.hideProgressBG()
        }
        
        // Trim the given display name.
        let trimmedDisplayName = displayName.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines )

        // Check if display name need to be updated.
        if trimmedDisplayName != FirebaseUser.Instance.displayName
        {
            // Send a request to update user display name.
            FirebaseUser.Instance.updateDisplayName( name: trimmedDisplayName, onComplete: onComplete, onFailed: onFailed )
        }
        
        let trimmedEmail = email.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines )
        
        // Check if email address need to be updated.
        if trimmedEmail != FirebaseUser.Instance.email
        {
            // Create a custom on complete action.
            let customOnCompleteAction = {
                // Call onComplete action to update UI.
                onComplete()
                // Show email verification note.
                sender.verifiyEmailNotification.text! += " " + email
                sender.verifiyEmailNotification.isHidden = false
                // Send a verification email to the new email address.
                FirebaseUser.Instance.sendEmailVerification( onComplete: nil )
            }
            
            // Send a request to update user email address.
            FirebaseUser.Instance.updateEmail( email: trimmedEmail, onComplete: customOnCompleteAction, onFailed: onFailed )
        }
    }
    
    func downloadAvaImg( url: URL, avaPlaceHolder: UIImageView )
    {
        // Check if we have an avatar image.
        if !url.absoluteString.isEmpty
        {
            let imageData = try? Data( contentsOf: url )
            
            DispatchQueue.main.async {
                if imageData != nil
                {
                    avaPlaceHolder.image = UIImage( data: imageData! )
                }
            }
        }
    }
}
