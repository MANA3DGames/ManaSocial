//
//  ViewController.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/9/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController
{
    // UI element objects.
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

//    // Changes a placeholder color to red if it is empty.
//    func markRequiredPlaceholder( textField : UITextField )
//    {
//        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
//    }
    
    func quickRegistration()
    {
        let email = "kingodesu@gmail.com"
        let password = "1234"
        let firstName = "Amanda"
        let lastName = "AbuObaid"

        ServerAccess.registerNewUser(email: email, password: password, firstName: firstName, lastName: lastName)
    }
    
    // To be called when register btn is clicked.
    @IBAction func onClickRegisterBtn(_ sender: Any)
    {
        // check first name field.
        if firstNameTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: firstNameTxt, color: UIColor.red )
            return
        }
        // Check last name field.
        if lastNameTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: lastNameTxt, color: UIColor.red )
            return
        }

        // Check email field.
        if emailTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: emailTxt, color: UIColor.red )
            return
        }

        // Check password field.
        if passwordTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: passwordTxt, color: UIColor.red )
            return
        }
        // Check re-password field.
        if repasswordTxt.text!.isEmpty
        {
            UIUtilities.setTextFieldPlaceHolderColor( textField: repasswordTxt, color: UIColor.red )
            return
        }
        if passwordTxt.text != repasswordTxt.text
        {
            repasswordTxt.text = ""
            return;
        }
        
        // All registration fields were filled.
        ServerAccess.registerNewUser(
            email: emailTxt.text!.lowercased(),
            password: passwordTxt.text!,
            firstName: firstNameTxt.text!,
            lastName: lastNameTxt.text! )
    }
    
}
