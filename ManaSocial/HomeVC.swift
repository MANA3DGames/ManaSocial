//
//  HomeVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class HomeVC: UIViewController
{
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Fill user's details.
        fullNameLabel.text = userData?["firstname"] as? String
        fullNameLabel.text?.append( " " + (userData?["lastname"] as? String)! )
        emailLabel.text = userData?["email"] as? String
    }
    
    
    @IBAction func onEditProfileBtnClicked(_ sender: Any)
    {
    }
}
