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
    @IBOutlet weak var displayNameTxt: UITextField!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var verifiyEmailNotification: UILabel!
    
    let editProfileModel = EditProfileModel()
    
    var currentDisplayName = ""
    var currentEmail = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // We need a progress indicator here.
        createProgressBG()

        // Set current navigation title.
        navigationItem.title = "UPDATE PROFILE"

        editProfileModel.fillUserInfo( self )

        saveCurrentInfoTemporarily()
        
        // Make avaImg round corners.
        avaImg.layer.cornerRadius = avaImg.bounds.width / 3
        avaImg.clipsToBounds = true

        // Customize saveBtn
        saveBtn.layer.cornerRadius = saveBtn.bounds.width / 12
        saveBtn.backgroundColor = MCOLOR_BLACK

        // Disable save btn at the beginning.
        disableSaveBtn()

        // Hide email verification note.
        verifiyEmailNotification.isHidden = true

        // Delegating textfields:
        emailTxt.delegate = self
        displayNameTxt.delegate = self

        // Add target to textfield to execute texfield func
        emailTxt.addTarget( self, action: #selector( EditProfileVC.textFieldDidChangeSelection(_:) ), for: UIControl.Event.editingChanged )
        displayNameTxt.addTarget( self, action: #selector( EditProfileVC.textFieldDidChangeSelection(_:) ), for: UIControl.Event.editingChanged )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        if !progressBGImg!.isHidden
        {
            saveCurrentInfoTemporarily()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        // Check if there are empty input fields.
        if emailTxt.text!.isEmpty || displayNameTxt.text!.isEmpty || ( displayNameTxt.text! == currentDisplayName && emailTxt.text! == currentEmail )
        {
            // Disable save btn.
            disableSaveBtn()
        }
        else
        {
            // There is no empty field. so we can enable save btn.
            enableSaveBtn()
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String ) -> Bool
//    {
//        // Check if there are empty input fields.
//        if emailTxt.text!.isEmpty || displayNameTxt.text!.isEmpty || ( displayNameTxt.text! == currentDisplayName && emailTxt.text! == currentEmail )
//        {
//            // Disable save btn.
//            disableSaveBtn()
//        }
//        else
//        {
//            // There is no empty field. so we can enable save btn.
//            enableSaveBtn()
//        }
//
//        return true
//    }
    
    
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
    
    func saveCurrentInfoTemporarily()
    {
        // Save temp info.
        currentDisplayName = displayNameTxt.text!
        currentEmail = emailTxt.text!
    }
    
    
    
    @IBAction func onSaveBtnClicked(_ sender: Any)
    {
        // Check email field.
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        // Check display name field.
        if checkIsEmpty( textField: displayNameTxt )
        {
            return
        }
        
        // Remove keyboard.
        self.view.endEditing( true )
        
        // Send update request.
        editProfileModel.updateUserProfile( displayName: displayNameTxt.text!, email: emailTxt.text!, sender: self )
    }
}
