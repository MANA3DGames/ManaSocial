//
//  UsersVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/27/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class UsersVC: UITableViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var usersArray = [AnyObject]()
    var usersAvaArray = [UIImage]()
    
    var canSearch = true
    var lastSearchedKeyword = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Search bar customization.
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = blueColorBG
        searchBar.showsCancelButton = false
        
        searchForUsers( searchBar: searchBar, keyword: "" )
    }

    
    func cleanUpSavedData()
    {
        self.usersArray.removeAll( keepingCapacity: false )
        self.usersAvaArray.removeAll( keepingCapacity: false )
        self.tableView.reloadData()
    }
    
    // Triggered when search bar text changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchForUsers( searchBar: searchBar, keyword: searchText )
    }
    
    func searchForUsers( searchBar: UISearchBar, keyword: String )
    {
        // Check if we cannot do a search?
        if !canSearch
        {
            return
        }
        
        canSearch = false
        lastSearchedKeyword = keyword
        
        //let keyword = searchBar.text?.stringByTrimmingCharactersInSet
        ServerAccess.searchUsers( keyword: keyword, id: userData!["id"] as! String, onComplete: { (_ users: [AnyObject] ) in
            
            DispatchQueue.main.async {
                // Clear current data.
                self.cleanUpSavedData()
                
                // Save new users data.
                self.usersArray = users
                
                // Download users avatars.
                for i in 0 ..< self.usersArray.count
                {
                    // Get avatar path.
                    let ava = self.usersArray[i]["ava"] as? String
                    
                    // Check if we have a vaild path?
                    if !ava!.isEmpty
                    {
                        let url = URL( string: ava! )!
                        let imgData = try? Data( contentsOf: url )
                        let image = UIImage( data: imgData! )
                        self.usersAvaArray.append( image! )
                    }
                    else
                    {
                        let image = UIImage( named: "profileIcon.png" )
                        self.usersAvaArray.append( image! )
                    }
                }
                
                // Reload the table.
                self.tableView.reloadData()
            }
            
        } )
        
        Timer.scheduledTimer( withTimeInterval: 0.1, repeats: false, block: {_ in
            self.canSearch = true
            
            if self.lastSearchedKeyword != searchBar.text!
            {
                self.searchForUsers( searchBar: searchBar, keyword: searchBar.text! )
            }
        } )
    }
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        // Reset UI.
        searchBar.endEditing( false )
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        // Clean saved date.
        self.cleanUpSavedData()
        
        searchForUsers( searchBar: searchBar, keyword: "" )
    }
    
    
    // Returns cell count.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return usersArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell( withIdentifier: "cell", for: indexPath ) as! UserCell
        
        // Get found user one by one.
        let user = usersArray[indexPath.row]
        
        cell.userName.text = ( user["firstname"] as? String )! + " " + ( user["lastname"] as? String )!
        cell.avaImg.image = usersAvaArray[indexPath.row]
        
        return cell
    }
}
