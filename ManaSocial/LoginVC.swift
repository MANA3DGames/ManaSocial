//
//  LoginVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/14/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class LoginVC: MyBaseViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    let model = LoginModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func onLoginBtnClicked(_ sender: Any)
    {
        // Check if email textfield is empty?
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        // Check if password textfield is empty?
        if checkIsEmpty( textField: passwordTxt )
        {
            return
        }
        
        // Hide keyboard.
        self.view.endEditing( true )
        
        // Send login request.
        model.login( email: emailTxt.text!.lowercased(), password: passwordTxt.text! )
    }
    
    @IBAction func onForgetPasswordBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: ID_RESET_PASSWORD_VC )
    }
    
    @IBAction func onRegisterBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: ID_REGISTER_VC )
    }
}
