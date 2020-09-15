import Foundation

class ResetPasswordModel
{
    func resetPassword(_ email: String, sender: ResetPasswordVC )
    {
        sender.showProgressBG()
        
        FirebaseUser.Instance.resetPassword(
            email: email,
            onComplete: {
                MPopup.display( message: "Please check your email to reset your password", bgColor: UIInfo.MCOLOR_GREEN, onComplete: nil )
                sender.hideProgressBG()
            },
            onFailed: { error in
                MPopup.display( message: error, bgColor: UIInfo.MCOLOR_RED, onComplete: nil )
                sender.hideProgressBG()
        } )
    }
}
