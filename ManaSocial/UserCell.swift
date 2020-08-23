//
//  UserCell.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/27/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

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
        userName.textColor = blackColorBG
    }
    
    
}
