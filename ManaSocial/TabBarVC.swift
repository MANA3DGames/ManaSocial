//
//  TabBarVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Items color.
        self.tabBar.tintColor = .white
        
        // Background color.
        self.tabBar.barTintColor = blueColorBG
        
        // Disable translucent.
        self.tabBar.isTranslucent = false
        
        // Color of the text under icon in the tabBar controller.
        UITabBarItem.appearance().setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: grayColorLight], for: .normal )
        UITabBarItem.appearance().setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected )
        
        // New color for all icons of the tabBar controller.
        for item in self.tabBar.items! as [UITabBarItem]
        {
            if let image = item.image
            {
                item.image = image.setImageColor( color: grayColorLight ).withRenderingMode( .alwaysOriginal )
            }
        }
        
        // Play MANA Logo animation.
        manaAnimation()
    }
    
    
    func manaAnimation()
    {
        // Blue layer
        let layer = UIView()
        layer.frame = self.view.frame
        layer.backgroundColor = blueColorBG
        self.view.addSubview( layer )
        
        // Brand icon.
        let icon = UIImageView()
        icon.image = UIImage( named: "manaIcon.png" )
        icon.frame.size.width = 100
        icon.frame.size.height = 100
        icon.center = view.center
        self.view.addSubview( icon )
        
        // Start animation
        UIView.animate( withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            icon.transform = CGAffineTransform( scaleX: 0.9, y: 0.9 )
        } ) { ( finished: Bool ) in
            
            if finished
            {
                // second transformation.
                UIView.animate( withDuration: 0.5, animations: {
                    
                    // Make the icon bigger.
                    icon.transform = CGAffineTransform( scaleX: 20, y: 20 )
                    
                    // 3rd transformation.
                    UIView.animate( withDuration: 0.1, delay: 0.3, options: .curveLinear, animations: {
                        // Hide layer
                        icon.alpha = 0
                        layer.alpha = 0
                    }, completion: nil )
                    
                } )
            }
        }
    }
}

extension UIImage
{
    // Customize our UIImage for our icon.
    func setImageColor( color: UIColor ) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions( self.size, false, self.scale )
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy( x: 0, y: self.size.height )
        context.scaleBy( x: 1.0, y: -1.0 )
        
        let rect = CGRect( x: 0, y: 0, width: self.size.width, height: self.size.height ) as CGRect
        context.clip( to: rect, mask: self.cgImage! )
        
        color.setFill()
        context.fill( rect )
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext() as UIImage?
        UIGraphicsEndImageContext()
        
        return newImg!
    }
}
