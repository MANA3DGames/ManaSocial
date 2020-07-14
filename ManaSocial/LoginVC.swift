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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginBtnClicked(_ sender: Any)
    {
        if emailTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: emailTxt, color: UIColor.red )
            return
        }
        
        if passwordTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: passwordTxt, color: UIColor.red )
            return
        }
        
        ServerAccess.loginUser( email: emailTxt.text!.lowercased(), password: passwordTxt.text! )
    }
}
