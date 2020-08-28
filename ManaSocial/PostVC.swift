//
//  PostVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/23/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class PostVC: MyBaseViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var textTxt: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var uploadedImgView: UIImageView!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    
    // Indicates whether the user did really pick up an image to be uploaded with the post or did not.
    var didPickupImage = false
    
    let MAX_CHARS = 240
    
    let postModel = PostModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounded cornors.
        textTxt.layer.cornerRadius = textTxt.bounds.width / 50
        postBtn.layer.cornerRadius = postBtn.bounds.width / 20
        
        // Set Colors.
        uploadImgBtn.setTitleColor( MCOLOR_BLACK, for: .normal )
        postBtn.backgroundColor = MCOLOR_BLACK
        countLabel.textColor = MCOLOR_LIGHT_GRAY
        
        // Disable auto scroll layout.
        //self.automaticallyAdjustsScrollViewInsets = false
        textTxt.contentInsetAdjustmentBehavior = .never
        
        // Disable post btn at the beginning
        disablePostBtn()
    }
    
    func disablePostBtn()
    {
        postBtn.isEnabled = false
        postBtn.alpha = 0.4
    }
    func enablePostBtn()
    {
        postBtn.isEnabled = true
        postBtn.alpha = 1
    }
    
    // Delegate triggered when textView changed.
    func textViewDidChange(_ textView: UITextView )
    {
        // Get the number of characters
        let charsCount = textView.text.count
        
        // Set remining characters count in the 'countLabel'
        countLabel.text = String( MAX_CHARS - charsCount )
        
        // define white spacing.
        let spacing = NSCharacterSet.whitespacesAndNewlines
        
        // Check if we don't have valid input?
        if charsCount > MAX_CHARS || textView.text.trimmingCharacters( in: spacing ).isEmpty
        {
            // Disable post button as we have invaild input.
            disablePostBtn()
            
            if charsCount > MAX_CHARS
            {
                countLabel.textColor = MCOLOR_RED;
            }
        }
        else
        {
            // Enable post button.
            enablePostBtn()
            
            // Reset count label text color.
            countLabel.textColor = MCOLOR_LIGHT_GRAY;
        }
    }
    
    // Triggered when user picked up an image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] )
    {
        didPickupImage = true
        
        uploadedImgView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss( animated: true, completion: nil )
    }
    
    // To be triggered after post request completed successfully.
    func onPostUploaded()
    {
        // Get back to main queue.
        DispatchQueue.main.sync {
            // Reset everything to start brand new post.
            self.didPickupImage = false
            self.textTxt.text = ""
            self.countLabel.text = String( MAX_CHARS )
            self.uploadedImgView.image = nil
            
            disablePostBtn()
            
            // Switch to another scene.
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    // Triggered when user clicks UploadImageBtn.
    @IBAction func onUploadImgBtnClicked(_ sender: Any)
    {
        didPickupImage = false
        
        // Create a new image picker.
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present( picker, animated: true, completion: nil )
    }
    
    @IBAction func onPostBtnClicked(_ sender: Any)
    {
        if !textTxt.text.isEmpty && textTxt.text.count <= MAX_CHARS
        {
            postModel.uploadPost(
                id: FirebaseUser.Instance.uid,
                text: textTxt.text,
                didPickupImage: didPickupImage,
                imageView: uploadedImgView,
                onComplete: onPostUploaded )
        }
    }
}
