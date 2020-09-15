import UIKit

class UserCell: UITableViewCell
{
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Round corners.
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        // Set color.
        userName.textColor = UIInfo.MCOLOR_BLACK
    }
}
