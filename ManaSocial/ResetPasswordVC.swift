//
//  ResetPasswordVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/16/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class ResetPasswordVC: MyBaseViewController
{
    @IBOutlet weak var emailTxt: UITextField!
    
    let resetpasswordModel = ResetPasswordModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createProgressBG()
    }
    
    @IBAction func onResetBtnClicked(_ sender: Any)
    {
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        // Hide keyboard.
        self.view.endEditing( true )
        
        // Send reset password request.
        resetpasswordModel.resetPassword( emailTxt.text!, sender: self )
    }
    
    @IBAction func onGoBackBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: ID_LOGIN_VC )
    }
}
