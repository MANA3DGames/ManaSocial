import Foundation
import UIKit
import FirebaseFirestore

class HomeBaseViewController : MyBaseViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!

    @IBOutlet weak var tableView: UITableView!
    var postsArray = [DocumentSnapshot]()
    var postImagesArray = [UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // Pre-load func.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        
        // Clear current data
        postsArray.removeAll( keepingCapacity: false )
        postImagesArray.removeAll( keepingCapacity: false )
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
        let cell = tableView.dequeueReusableCell( withIdentifier: VCIDInfo.ID_CELL, for: indexPath ) as! PostCell
        cell.postFullnameLabel.text = post.get( FirestoreFields.User.Post.poster ) as? String
            cell.postTextLabel.text = post.get( FirestoreFields.User.Post.text ) as? String
        
        // Set post image.
        let image = postImagesArray[indexPath.row]
        cell.postImgView.image = image
        
        // Convert date string to date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.init( identifier: "en_US" )
        dateFormatter.timeZone = TimeZone.init( abbreviation: "UTC" )
        let newDate = dateFormatter.date( from: post.documentID )
        
        // Date settings:
        let now = Date()
        let components = Set<Calendar.Component>( [.second, .minute, .hour, .day, .weekOfMonth] )
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
                cell.postTextLabel.frame.origin.x = 20
            }
        }
        
        return cell
    }
    
    
    func downloadPosts( userID: String, model: HomeBaseModel )
    {
        // Load all user's post.
        model.downloadPosts( userID: userID, onComplete: { (_ posts : [DocumentSnapshot] ) in
            DispatchQueue.main.async {
                // Set global postsArray to the posts value that we've just got.
                self.postsArray = posts;
                
                // Download post images.
                for i in 0 ..< self.postsArray.count
                //for i in stride( from: self.postsArray.count-1, to: 0, by: -1 )
                {
                    // Get current post image.
                    let imgPath = self.postsArray[i].get( FirestoreFields.User.Post.imgUrl ) as? String

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
                
                self.postsArray.reverse()
                self.postImagesArray.reverse()

                self.tableView.reloadData()
            }
        }, onFailed: { ( error ) in
            self.downloadPosts( userID: userID, model: model )
        } )
    }
}
