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
}
