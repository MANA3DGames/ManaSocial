import Foundation
import FirebaseAuth

class LoginModel
{
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
                    // Save user password.
                    FirebaseUser.Instance.tempPass = password
                    // Go to register view controller then display verification view.
                    sender.moveToViewController( from: sender, toID: VCIDInfo.ID_REGISTER_VC )
                }
                // User's email address was verified successfully.
                else
                {
                    // Notify user about signing in.
                    MPopup.display( message: "User has been signed in successffully", bgColor: UIInfo.MCOLOR_GREEN, onComplete: {
                        sceneDelegate.goToTabBarController()
                        sender.hideProgressBG()
                    } )
                }
            }
            else if error != nil
            {
                let msg = error?.localizedDescription ?? ""
                MPopup.display( message: msg, bgColor: UIInfo.MCOLOR_RED, onComplete: nil )
                sender.hideProgressBG()
            }
        }
    }
}
