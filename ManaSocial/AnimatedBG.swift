//
//  AnimatedBG.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/24/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class AnimatedBG
{
    // Animated background image.
    let bgImg = UIImageView()
    
    // Initial target x position which will be used to animate background image.
    var initTargetXBGAnimation : CGFloat = 0.0
    
    
    init( window: UIWindow ) {
        
        // Creating imageView to store background image
        bgImg.frame = CGRect( x: 0, y: 0, width: window.bounds.width * 1.688, height: window.bounds.height )
        bgImg.image = UIImage( named: "bgImg.jpg" )
        window.addSubview( bgImg )
        window.makeKeyAndVisible()
        
        // Set initTargetXBGAnimation to the most right end of the image.
        initTargetXBGAnimation = -self.bgImg.bounds.width + window.bounds.width
        
        // Start animating the background.
        animate( targetX: initTargetXBGAnimation )
    }
    
    deinit {
        
    }
    
    func animate( targetX: CGFloat )
    {
        UIView.animate( withDuration: 15,
                        animations: { self.bgImg.frame.origin.x = targetX } )
                        { ( finished: Bool ) in
                            if finished
                            {
                                // Declare next x target.
                                var nextTargetX = CGFloat( 0.0 )
                                
                                // Check if current x target is equal to 0?
                                if targetX == 0.0
                                {
                                    // Then set nextTargetX to the end of the image. (otherwise it will stay zero).
                                    nextTargetX = self.initTargetXBGAnimation
                                }
                                
                                // Call animateBG with the new nextTargetX to make PingPong effect.
                                self.animate( targetX: nextTargetX )
                            }
                        }
    }
}
