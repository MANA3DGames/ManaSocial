//
//  ResetPasswordVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/16/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController
{
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onResetBtnClicked(_ sender: Any)
    {
        if UIUtilities.checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        print( "Reset password" )
    }
    
}
