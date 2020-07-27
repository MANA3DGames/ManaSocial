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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Search bar customization.
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = blueColorBG
        searchBar.showsCancelButton = false
    }

    
    // Triggered when search bar text changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //print( searchText )
    }
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing( false )
        searchBar.showsCancelButton = false
        searchBar.text = ""
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
        
        return cell
    }
    
}
