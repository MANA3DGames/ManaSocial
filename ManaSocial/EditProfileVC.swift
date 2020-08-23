//
//  EditProfileVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/30/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class EditProfileVC: MyBaseViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    let editProfileModel = EditProfileModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "UPDATE PROFILE"
        
        emailTxt.text = userData!["email"] as? String
        firstNameTxt.text = userData!["firstname"] as? String
        lastNameTxt.text = userData!["lastname"] as? String
        fullnameLabel.text = "\(firstNameTxt.text!) \(lastNameTxt.text!)"
        
        // Download avatar image.
        let avaUrl = ( userData!["ava"] as? String ) ?? ""
        editProfileModel.downloadAvaImg( avaUrl: avaUrl, avaPlaceHolder: self.avaImg )
        
        // Make avaImg round corners.
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        // Customize saveBtn
        saveBtn.layer.cornerRadius = saveBtn.bounds.width / 9
        saveBtn.backgroundColor = blackColorBG
        
        // Disable save btn at the beginning.
        disableSaveBtn()
        
        
        // Delegating textfields:
        emailTxt.delegate = self
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        
        // Add target to textfield to execute texfield func
        firstNameTxt.addTarget( self, action: #selector( EditProfileVC.textFieldDidChangeSelection(_:) ), for: UIControl.Event.editingChanged )
        lastNameTxt.addTarget( self, action: #selector( EditProfileVC.textFieldDidChangeSelection(_:) ), for: UIControl.Event.editingChanged )
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        // Update fullname label.
        fullnameLabel.text = "\(firstNameTxt.text!) \(lastNameTxt.text!)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String ) -> Bool
    {
        // Check if there are empty input fields.
        if emailTxt.text!.isEmpty || firstNameTxt.text!.isEmpty || lastNameTxt.text!.isEmpty
        {
            // Disable save btn.
            disableSaveBtn()
        }
        else
        {
            // There is no empty field. so we can enable save btn.
            enableSaveBtn()
        }
        
        return true
    }
    
    
    func enableSaveBtn()
    {
        saveBtn.isEnabled = true
        saveBtn.alpha = 1
    }
    func disableSaveBtn()
    {
        saveBtn.isEnabled = false
        saveBtn.alpha = 0.4
    }
    
    
    
    @IBAction func onSaveBtnClicked(_ sender: Any)
    {
        // Check email field.
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        // check first name field.
        if checkIsEmpty( textField: firstNameTxt )
        {
            return
        }
        
        // Check last name field.
        if checkIsEmpty( textField: lastNameTxt )
        {
            return
        }
        
        // Remove keyboard.
        self.view.endEditing( true )
        
        // Send update request.
        editProfileModel.updateUserProfile(
            firstName: firstNameTxt.text!,
            lastName: lastNameTxt.text!,
            email: emailTxt.text!,
            id: userData!["id"] as! String )
    }
}
