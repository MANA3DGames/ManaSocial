//
//  LoginVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/14/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func onLoginBtnClicked(_ sender: Any)
    {
        if UIUtilities.checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        if UIUtilities.checkIsEmpty( textField: passwordTxt )
        {
            return
        }
        
        ServerAccess.loginUser( email: emailTxt.text!.lowercased(), password: passwordTxt.text! )
    }
}
