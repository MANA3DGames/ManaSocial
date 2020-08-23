//
//  PostCell.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/25/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell
{
    @IBOutlet weak var postFullnameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Colors
        postFullnameLabel.textColor = blackColorBG
        
        // Rounded Corners.
        postImgView.layer.cornerRadius = postImgView.bounds.width / 20
        postImgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
