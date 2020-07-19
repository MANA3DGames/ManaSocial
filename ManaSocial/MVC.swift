//
//  MVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class MVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Return white status bar.
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    
    // Changes placeholder text color.
    func setTextFieldPlaceHolderColor( textField: UITextField, color: UIColor )
    {
        textField.attributedPlaceholder = NSAttributedString( string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color] )
    }
    
    // Checks if the given input field is empty.
    func checkIsEmpty( textField: UITextField ) -> Bool
    {
        if textField.text!.isEmpty
        {
            setTextFieldPlaceHolderColor( textField: textField, color: UIColor.red )
            return true
        }
        
        return false
    }
    
    // Returns the most top view controller.
    func getTopViewController() -> UIViewController?
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
    func moveToViewController( from: UIViewController, toID: String )
    {
        from.dismiss( animated: false, completion: {
            let storyboard = UIStoryboard( name: "Main", bundle: nil )
            let nextVC = storyboard.instantiateViewController( identifier: toID )
            nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.getTopViewController()?.present( nextVC, animated: false, completion: nil )
        } )
    }
    
}
