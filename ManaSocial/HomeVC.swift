import UIKit

class HomeVC: HomeBaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    let homeModel = HomeModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createProgressBG()
    }
    
    // Pre-load func.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        // Fill in user information in the corresponding ui elements.
        homeModel.fillUserInfo( sender: self, name: FirebaseUser.Instance.displayName, uid: FirebaseUser.Instance.uid )
        
        downloadPosts( userID: FirebaseUser.Instance.uid, model: homeModel )
    }

    @IBAction func onEditProfileBtnClicked(_ sender: Any)
    {
        // Create a new action sheet.
        let sheet = UIAlertController( title: "Edit Profile", message: nil, preferredStyle: UIAlertController.Style.actionSheet )
        
        // Create cancel btn.
        let cancelBtn = UIAlertAction( title: "Cancel", style: .cancel, handler: nil )
        
        // Create pickup picture btn.
        let pickImgBtn = UIAlertAction( title: "Change Profile Picture", style: .default, handler: { ( action: UIAlertAction ) in
            self.pickUpImage()
        } )
        
        // Create edit btn.
        let updateBtn = UIAlertAction( title: "Update Profile", style: .default, handler: { ( action: UIAlertAction ) in
            
            // Go to EditProfileVC
            let storyboard = UIStoryboard( name: VCIDInfo.ID_EDIT_PROFILE_VC, bundle: nil )
            let editVC = storyboard.instantiateViewController( identifier: VCIDInfo.ID_EDIT_PROFILE_VC ) as! EditProfileVC
            self.navigationController?.pushViewController( editVC, animated: true )
            
            // Remove title from back button.
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
        } )
        
        // Add all actions/btns to the sheet.
        sheet.addAction( cancelBtn )
        sheet.addAction( pickImgBtn )
        sheet.addAction( updateBtn )
        
        // Display action sheet.
        self.present( sheet, animated: true, completion: nil )
    }
    
    func pickUpImage()
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
        FirebaseUser.Instance.uploadAvaImage( avaImg.image! )
    }

    @IBAction func onSignoutBtnClicked(_ sender: Any)
    {
        FirebaseUser.Instance.signout()
        
        // Go back to login menu.
        moveToViewController( from: self, toID: VCIDInfo.ID_LOGIN_VC )
    }

    // Allows cells in table view to be edited.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // When cell swiped.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // Check if we pressed on delete button of swiped cell?
        if editingStyle == .delete
        {
            homeModel.deletePost( sender: self, forRowAt: indexPath )
        }
    }
}
