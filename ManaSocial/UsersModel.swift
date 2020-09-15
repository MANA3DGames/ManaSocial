import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DownloadedFBUser
{
    var document : DocumentSnapshot?
    var image : UIImage?
}

class UsersModel
{
    var usersDic = Dictionary<Int, DownloadedFBUser>()
    
    var canSearch = true
    var lastSearchedKeyword = ""

    func cleanUpSavedData(_ sender: UsersVC )
    {
        self.usersDic.removeAll( keepingCapacity: false )
        sender.tableView.reloadData()
    }

    func getRandomUsers( searchBar: UISearchBar, sender: UsersVC )
    {
        FirebaseUser.Instance.getRandomUsers( onComplete: { (_ users: [AnyObject] ) in
            self.onReceiveUsers( searchBar: searchBar, sender: sender, users: users )
        }, onFailed: nil )
    }
    
    func searchForUsers( searchBar: UISearchBar, keyword: String, sender: UsersVC )
    {
        FirebaseUser.Instance.searchForUsers( keyword: keyword, onComplete: { (_ users: [AnyObject] ) in
            self.onReceiveUsers( searchBar: searchBar, sender: sender, users: users )
        }, onFailed: nil )
    }
    
    func onReceiveUsers( searchBar: UISearchBar, sender: UsersVC, users: [AnyObject] )
    {
        // Clear current data.
        self.cleanUpSavedData( sender )
        
        var count = users.count
        if count > 10
        {
            count = 10
        }
        
        // Save new users data.
        for index in 0 ..< count
        {
            // Check if this is the same current signed in user.
            let document = users[index] as? DocumentSnapshot
            
            self.usersDic[index] = DownloadedFBUser()
            self.usersDic[index]!.document = document
            
            FirebaseFiles.downloadAvaImg( userID: self.usersDic[index]!.document!.documentID, onComplete: { ( img ) in
                
                if self.usersDic[index] != nil
                {
                    if img != nil
                    {
                        self.usersDic[index]!.image = img!
                    }
                    else
                    {
                        self.usersDic[index]!.image = UIImage( named: UIInfo.PROFILE_ICON_NAME )!
                    }
                    
                    // Reload the table.
                    sender.tableView.reloadData()
                }

            }, onFailed: { ( error ) in

                if self.usersDic[index] != nil
                {
                    self.usersDic[index]!.image = UIImage( named: UIInfo.PROFILE_ICON_NAME )!

                    // Reload the table.
                    sender.tableView.reloadData()
                }
            } )
        }
        
        // Reload the table.
        sender.tableView.reloadData()
    }
    
    func createUserCell( tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UserCell
    {
        let cell = tableView.dequeueReusableCell( withIdentifier: VCIDInfo.ID_CELL, for: indexPath ) as! UserCell
        
        // Get found user one by one.
        let user = usersDic[indexPath.row]
        
        cell.userName.text = user?.document!.get( FirestoreFields.User.name ) as? String
        cell.avaImg.image = user?.image

        return cell
    }
    
    func visitProfile( for segue: UIStoryboardSegue, sender: Any?, usersView: UsersVC )
    {
        // Check if there is a selected cell?
        if let cell = sender as? UITableViewCell
        {
            // Get index of the selected cell.
            let index = usersView.tableView.indexPath( for: cell )!.row
            
            // Check if segue is a guest?
            if segue.identifier == VCIDInfo.ID_Guest
            {
//                // Cehck if this is not the current user otherwise we want to go to our home page.
//                if usersDic[index]?.document?.documentID != FirebaseUser.Instance.uid
                
                // Get GuestVC instance.
                let guestVC = segue.destination as! GuestVC
                
                // Set guest info.
                guestVC.document = usersDic[index]?.document
                
                // Craete a new back button.
                let backBtn = UIBarButtonItem()
                backBtn.title = ""
                usersView.navigationItem.backBarButtonItem = backBtn
            }
        }
    }
}
