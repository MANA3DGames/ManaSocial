//
//  HomeVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class HomeVC: MVC, UINavigationControllerDelegate, UIImagePickerControllerDelegate
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
        
        // Download profile image using 'ava' link from saved userData.
        ServerAccess.downloadImg( link: ( userData?["ava"] as? String )!, view: avaImg )
        
        // Rounded Corners.
        avaImg.layer.cornerRadius = avaImg.bounds.width / 20
        avaImg.clipsToBounds = true
        self.navigationItem.title = fullNameLabel.text
    }
    
    
    @IBAction func onEditProfileBtnClicked(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present( picker, animated: true, completion: nil )
    }
    
    // Triggered when user picked up an image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss( animated: true, completion: nil )
        
        // Upload selected image to our database server.
        ServerAccess.uploadAvaImage( id: userData!["id"] as! String, image: avaImg.image! )
    }
    
    
    @IBAction func onSignoutBtnClicked(_ sender: Any)
    {
        // Clear user saved data.
        sceneDelegate.clearUserData()
        
        // Go back to login menu.
        moveToViewController( from: self, toID: ID_LOGIN_VC )
    }
}
