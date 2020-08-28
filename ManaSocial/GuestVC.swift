//
//  GuestVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/29/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class GuestVC: HomeBaseViewController //MyBaseViewController, UITableViewDelegate, UITableViewDataSource
{
    // Variable to store guest info passed with segue.
    var document : DocumentSnapshot?
    
    let guestModel = GuestModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Fill user's details.
        guestModel.fillUserInfo( sender: self, name: document!.get( "name" ) as! String, uid: document!.documentID )
    }
    
    // Pre-load func.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        //downloadPosts()
    }
}
