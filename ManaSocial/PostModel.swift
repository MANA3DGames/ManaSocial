import Foundation
import UIKit

class PostModel
{
    func uploadPost( text: String, imageView: UIImageView, onComplete: @escaping ()-> Void, onFailed: @escaping ()-> Void )
    {
        FirebaseUser.Instance.uploadPost( text: text, image: imageView.image, onComplete: onComplete, onFailed: { ( error ) in
            MPopup.display(message: error, bgColor: UIInfo.MCOLOR_RED, onComplete: onFailed )
        } )
    }
}
