import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class GuestVC: HomeBaseViewController
{
    // Variable to store guest info passed with segue.
    var document : DocumentSnapshot?
    
    let guestModel = GuestModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Fill user's details.
        guestModel.fillUserInfo( sender: self, name: document!.get( FirestoreFields.User.name ) as! String, uid: document!.documentID )
    }
    
    // Pre-load func.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        downloadPosts( userID: document!.documentID, model: guestModel )
    }
}
