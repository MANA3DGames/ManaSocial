//
//  ViewController.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/9/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: MyBaseViewController
{
    // Registration UI.
    @IBOutlet weak var passwordTxt: UITextField!        // User's password ui input field.
    @IBOutlet weak var repasswordTxt: UITextField!      // User's confirm-password ui input field.
    @IBOutlet weak var emailTxt: UITextField!           // User's email ui input field.
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    // Verification UI.
    @IBOutlet weak var verificationView: UIView!
    @IBOutlet weak var waitingForVerifiationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resendEmailBtn: UIButton!
    
    
    let registerModel = RegisterModel()
    
    var firebaseHandle : AuthStateDidChangeListenerHandle?
    
    
    
    // Startup function.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Create a progress background.
        createProgressBG()
        
        // Rounded Corners
        verificationView.layer.cornerRadius = verificationView.bounds.width / 20
        verificationView.clipsToBounds = true
        
        // Prevent autofill.
        passwordTxt.textContentType = .oneTimeCode// .init( rawValue: "" )
        repasswordTxt.textContentType = .oneTimeCode// .init( rawValue: "" )
        
        // Check if we have been re-directed from login-view to verifiy email
        if FirebaseUser.Instance.isInitialized && !FirebaseUser.Instance.isEmailVerified
        {
            registerModel.onCompleteAction( self )
        }
        else
        {
            showRegistrationUI( true )
            showVerificationUI( false )
        }
    }
    
    
    func showRegistrationUI(_ show: Bool )
    {
        passwordTxt.isHidden = !show
        repasswordTxt.isHidden = !show
        emailTxt.isHidden = !show
        registerBtn.isHidden = !show
        loginBtn.isHidden = !show
    }
    func showVerificationUI(_ show: Bool )
    {
        verificationView.isHidden = !show
        resendEmailBtn.isHidden = !show
        
        if show
        {
            waitingForVerifiationIndicator.startAnimating()
        }
        else
        {
            waitingForVerifiationIndicator.stopAnimating()
        }
    }
    
    
    
    // To be called when register btn is clicked.
    @IBAction func onClickRegisterBtn(_ sender: Any)
    {
        // Check email field.
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }

        // Check password field.
        if checkIsEmpty( textField: passwordTxt )
        {
            return
        }
        // Check re-password field.
        if checkIsEmpty( textField: repasswordTxt )
        {
            return
        }
        
        // Check if password is confirmed correctly?
        if passwordTxt.text != repasswordTxt.text
        {
            repasswordTxt.text = ""
            return;
        }
        
        // Hide keyboard.
        self.view.endEditing( true )
        
        // Register a new user with the given crediantals.
        registerModel.register( email: emailTxt.text!.lowercased(), password: passwordTxt.text!, sender: self )
    }
    
    
    @IBAction func onAlreadyHaveAccountBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: ID_LOGIN_VC )
    }
    
    
    @IBAction func onResendEmailVerificationBtnClicked(_ sender: Any)
    {
        registerModel.resendEmailVerfication( self )
    }
}
