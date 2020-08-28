//
//  MPopup.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 8/24/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class MPopup
{
    // Indicates whether Popup view is displayed or not?
    static var isPopupDisplayed = false
    
    static func display( message: String, bgColor: UIColor, onComplete: ( () -> Void )? )
    {
        if isPopupDisplayed
        {
            return
        }
        
        isPopupDisplayed = true
        
        let wind = sceneDelegate.window!
        
        let popupViewHeight = wind.bounds.height / 14.2
        let popupViewY = 0 - popupViewHeight

        let popupView = UIView( frame: CGRect( x: 0, y: popupViewY, width: wind.bounds.width, height: popupViewHeight ) )
        popupView.backgroundColor = bgColor
        wind.addSubview( popupView )
        
        
        let msgLabelWidth = popupView.bounds.width
        let appHeight = wind.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let msgLabelHeight = popupView.bounds.height + appHeight / 2
        
        let popupLabel = UILabel()
        popupLabel.frame.size.width = msgLabelWidth
        popupLabel.frame.size.height = msgLabelHeight
        popupLabel.numberOfLines = 0
        popupLabel.text = message
        popupLabel.font = UIFont( name: "HelveticaNeue", size: FONT_SIZE_12 )
        popupLabel.textColor = UIColor.white
        popupLabel.textAlignment = NSTextAlignment.center
        
        popupView.addSubview( popupLabel )
        
        
        // Animate Popup view:
        UIView.animate(
            withDuration: 0.2,
            animations: { popupView.frame.origin.y = 0 },
            completion: { ( finished: Bool ) in
                if finished
                {
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 3,
                        options: .curveLinear,
                        animations: { popupView.frame.origin.y = popupViewY },
                        completion: { ( finished: Bool ) in
                            if finished
                            {
                                popupView.removeFromSuperview()
                                popupLabel.removeFromSuperview()
                                self.isPopupDisplayed = false
                                
                                onComplete?()
                            }
                        }
                    )
                }
            } )
    }
}
