import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class HomeModel : HomeBaseModel
{
    func deletePost( sender: HomeVC, forRowAt indexPath: IndexPath )
    {
        sender.showProgressBG()
        
        let post = sender.postsArray[indexPath.row]
        
        // Send php delete request.
        FirebaseUser.Instance.deletePost( postId: post.documentID, imgUrl: post.get( FirestoreFields.User.Post.imgUrl ) as! String, onComplete: {
            DispatchQueue.main.async {
                sender.postsArray.remove( at: indexPath.row )
                sender.postImagesArray.remove( at: indexPath.row )
                sender.tableView.deleteRows( at: [indexPath], with: UITableView.RowAnimation.automatic )
                
                sender.hideProgressBG()
            }
        }, onFailed: { error in
            MPopup.display( message: error, bgColor: UIInfo.MCOLOR_RED, onComplete: sender.hideProgressBG )
        } )
    }
    
    override func fillUserInfo( sender: HomeBaseViewController, name: String, uid: String )
    {
        super.fillUserInfo( sender: sender, name: name, uid: uid )
        
        sender.emailLabel.text = FirebaseUser.Instance.email
        sender.editProfileBtn.setTitleColor( UIInfo.MCOLOR_BLACK, for: .normal )
    }
}
