//
//  UIUtilities.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/14/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import Foundation
import UIKit

class UIUtilities
{
    // Changes placeholder text color.
    public static func setTextFieldPlaceHolderColor( textField: UITextField, color: UIColor )
    {
        textField.attributedPlaceholder = NSAttributedString( string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color] )
    }
    
    // Checks if the given input field is empty.
    public static func checkIsEmpty( textField: UITextField ) -> Bool
    {
        if textField.text!.isEmpty
        {
            setTextFieldPlaceHolderColor( textField: textField, color: UIColor.red )
            return true
        }
        
        return false
    }
    
    // Returns the most top view controller.
    public static func getTopViewController() -> UIViewController?
    {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
    
    // Moves from one view controller 'from' to another one 'toID'.
    public static func moveToViewController( from: UIViewController, toID: String )
    {
        from.dismiss( animated: false, completion: {
            let storyboard = UIStoryboard( name: "Main", bundle: nil )
            let nextVC = storyboard.instantiateViewController( identifier: toID )
            nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            UIUtilities.getTopViewController()?.present( nextVC, animated: false, completion: nil )
        } )
    }
}
