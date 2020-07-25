//
//  HomeVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class HomeVC: MVC, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    var postsArray = [AnyObject]()
    var postImagesArray = [UIImage]()
    
    
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
        
        editProfileBtn.setTitleColor( blueColorBG, for: .normal )
        
        //tableView.contentInset = UIEdgeInsets( top: 2, left: 0, bottom: 0, right: 0 )
    }
    // Pre-load func.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        // Clear current data
        postsArray.removeAll( keepingCapacity: false )
        postImagesArray.removeAll( keepingCapacity: false )
        
        // Load all user's post.
        ServerAccess.downloadPosts( id: userData!["id"]! as! String, onComplete: { (_ posts : [AnyObject] ) in
            DispatchQueue.main.async {
                // Set global postsArray to the posts value that we've just got.
                self.postsArray = posts;
                
                // Download post images.
                for i in 0 ..< self.postsArray.count
                {
                    // Get current post image.
                    let imgPath = self.postsArray[i]["path"] as? String
                    
                    var image = UIImage()
                    
                    // Check if there is a path for an image?
                    if !imgPath!.isEmpty
                    {
                        let url = URL( string: imgPath! )
                        let imageData = try? Data( contentsOf: url! )
                        image = UIImage( data: imageData! )!
                        
                    }
                    
                    self.postImagesArray.append( image )
                }
                
                self.tableView.reloadData()
            }
        } )
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return postsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        // Get post.
        let post = self.postsArray[indexPath.row]
        
        // Create a new cell.
        let cell = tableView.dequeueReusableCell( withIdentifier: "cell", for: indexPath ) as! PostCell
        cell.postFullnameLabel.text = ( post["firstname"] as? String )! + " " + ( post["lastname"] as? String )!
        cell.postTextLabel.text = post["text"] as? String
        
        // Set post image.
        let image = postImagesArray[indexPath.row]
        cell.postImgView.image = image
        
        // Convert date string to date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormatter.date( from: post["date"] as! String )
        
        // Date settings:
        let now = Date()
        let components = Set<Calendar.Component>( [.second, .minute, .hour, .day, .weekOfMonth] )
        //var calendar = Calendar.current
        //calendar.timeZone = TimeZone( identifier: "GMT+3" )!
        let difference = Calendar.current.dateComponents( components, from: newDate!, to: now )
        
        // Calculate date:
        if difference.weekOfMonth ?? 0 > 0
        {
            cell.postDateLabel.text = "\(String(describing: difference.weekOfMonth!))w."
        }
        else if difference.day ?? 0 > 0 && difference.weekOfMonth ?? 0 == 0
        {
            cell.postDateLabel.text = "\(String(describing: difference.day!))d."
        }
        else if difference.hour ?? 0 > 0 && difference.day ?? 0 == 0
        {
            cell.postDateLabel.text = "\(String(describing: difference.hour!))h."
        }
        else if difference.minute ?? 0 > 0 && difference.hour ?? 0 == 0
        {
            cell.postDateLabel.text = "\(String(describing: difference.minute!))m."
        }
        else if difference.second ?? 0 >= 1 && difference.minute ?? 0 == 0
        {
            cell.postDateLabel.text = "\(String(describing: difference.second!))s."
        }
        else if difference.second ?? 0 < 1
        {
            cell.postDateLabel.text = "Now."
        }
        
        // Move post text label to the most left of the screen if there is no image for the current post.
        DispatchQueue.main.async {
            if image.size.width == 0 && image.size.height == 0
            {
                cell.postTextLabel.frame.origin.x = self.view.frame.size.width / 16
                cell.postTextLabel.frame.size.width = self.view.frame.size.width - self.view.frame.size.width / 8
                cell.postTextLabel.sizeToFit()
            }
        }
        
        return cell
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
            let post = postsArray[indexPath.row]
            
            // Send php delete request.
            ServerAccess.deletePost( uuid: post["uuid"] as! String, path: post["path"] as! String, onComplete: {
                
                DispatchQueue.main.async {
                    print( "We got some data!" )
                    
                    self.postsArray.remove( at: indexPath.row )
                    self.postImagesArray.remove( at: indexPath.row )
                    self.tableView.deleteRows( at: [indexPath], with: UITableView.RowAnimation.automatic )
                }
            } )
        }
    }
    
}
