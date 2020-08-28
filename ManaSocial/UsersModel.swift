//
//  UsersModel.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/22/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

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
    //var usersArray = [DocumentSnapshot]()
    //var usersAvaArray = [UIImage]()
    var usersDic = Dictionary<Int, DownloadedFBUser>()
    
    var canSearch = true
    var lastSearchedKeyword = ""
    
    
    
    /// Deprecated: Please use Firebase func instead.
    func searchUsersPHP( keyword: String, id: String, onComplete: ( ( [AnyObject] ) -> Void )? )
    {
        let customOnComplete = { (_ json: Any, operation: ServerAccess.Operation ) in
            let jsonData = json as? [String: Any]
            if jsonData?["status"] as! String == "200"
            {
                onComplete!( jsonData?["users"] as! [AnyObject] )
            }
            ServerResponseHandler.onCompleteAction( json, operation )
        }
        
        let request = ServerAccess.createURLRequest(
            url: URL( string: ServerData.baseURL + "searchUsers.php" )!,
            method: ServerAccess.HttpMethod.POST,
            body: "keyword=\(keyword)&id=\(id)" )
        
        ServerAccess.executeDataTask(
            request: request,
            onCompleteAction: customOnComplete,
            onFailedAction: ServerResponseHandler.onFailedAction,
            operation: ServerAccess.Operation.NONE
        )
    }
    
    
    func cleanUpSavedData(_ sender: UsersVC )
    {
        //self.usersArray.removeAll( keepingCapacity: false )
        //self.usersAvaArray.removeAll( keepingCapacity: false )
        self.usersDic.removeAll( keepingCapacity: false )
        sender.tableView.reloadData()
    }

    func searchForUsers( searchBar: UISearchBar, keyword: String, sender: UsersVC )
    {
        FirebaseUser.Instance.searchForUsers( keyword: keyword, onComplete: { (_ users: [AnyObject] ) in
            
            // Clear current data.
            self.cleanUpSavedData( sender )
            
            // Save new users data.
            for i in 0 ..< users.count
            {
                // Check if this is the same current signed in user.
                let document = users[i] as? DocumentSnapshot
                if document?.documentID == FirebaseUser.Instance.uid
                {
                    // Skip this user as it is the same current logged user.
                    continue
                }
                
                self.usersDic[i] = DownloadedFBUser()
                self.usersDic[i]!.document = document
                
                FirebaseFiles.downloadAvaImg( userID: self.usersDic[i]!.document!.documentID, onComplete: { ( img ) in
                    
                    if self.usersDic[i] != nil
                    {
                        if img != nil
                        {
                            self.usersDic[i]!.image = img!
                        }
                        else
                        {
                            self.usersDic[i]!.image = UIImage( named: "profileIcon.png" )!
                        }
                        
                        // Reload the table.
                        sender.tableView.reloadData()
                    }

                }, onFailed: { ( error ) in

                    if self.usersDic[i] != nil
                    {
                        self.usersDic[i]!.image = UIImage( named: "profileIcon.png" )!

                        // Reload the table.
                        sender.tableView.reloadData()
                    }
                } )
            }
            
            // Reload the table.
            sender.tableView.reloadData()
            
        }, onFailed: nil )
    }
    
    
    func createUserCell( tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UserCell
    {
        let cell = tableView.dequeueReusableCell( withIdentifier: "cell", for: indexPath ) as! UserCell
        
        // Get found user one by one.
        let user = usersDic[indexPath.row]
        
        cell.userName.text = user?.document!.get( "name" ) as? String
        cell.avaImg.image = user?.image

        return cell
    }
    
    func visitProfile( for segue: UIStoryboardSegue, sender: Any?, usersView: UsersVC )
    {
        // Check if there is a selected cell?
        if let cell = sender as? UITableViewCell
        {
            // Get index of the selected cell.
            let index = usersView.tableView.indexPath( for: cell )!.row   // = indexPath.row
            
            // Check if segue is a guest?
            if segue.identifier == "Guest"
            {
                // Get GuestVC instance.
                let guestVC = segue.destination as! GuestVC
                
                // Set guest info.
                //guestVC.guest = usersArray[index] as? NSDictionary
                guestVC.document = usersDic[index]?.document
                
                // Craete a new back button.
                let backBtn = UIBarButtonItem()
                backBtn.title = ""
                usersView.navigationItem.backBarButtonItem = backBtn
            }
        }
    }
}
