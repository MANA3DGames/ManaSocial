//
//  MVC.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/19/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

class MyBaseViewController: UIViewController
{
    var progressBGImg: UIImageView?
    var progressIndicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // Return white status bar.
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    // On touch screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // Hide keyboard.
        self.view.endEditing( false )
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
            let storyboard = UIStoryboard( name: toID, bundle: nil )
            let nextVC = storyboard.instantiateViewController( identifier: toID )
            nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.getTopViewController()?.present( nextVC, animated: false, completion: nil )
        } )
    }
    
    
    func createProgressBG()
    {
        let wind = sceneDelegate.window!
        let wWidth = wind.bounds.width
        let wHeight = wind.bounds.height
        
        progressBGImg = UIImageView( frame: CGRect( x: 0, y: 0, width: wWidth, height: wHeight ) )
        progressBGImg!.backgroundColor = .black
        progressBGImg!.alpha = 0.6
        progressBGImg!.isUserInteractionEnabled = true
        // Add progressBG to this view controller.
        self.view.addSubview( progressBGImg! )
        
        progressIndicator = UIActivityIndicatorView( frame: CGRect( x: wWidth/2, y: wHeight/2, width: 20, height: 20 ) )
        progressIndicator!.style = .large
        progressIndicator!.color = .white
        
        // Add progress indicator to progressBG.
        progressBGImg!.addSubview( progressIndicator! )
        
        // Hide progress background for now.
        progressBGImg!.isHidden = true
    }
    
    
    func showProgressBG()
    {
        if progressBGImg != nil
        {
            progressBGImg!.isHidden = false
            progressIndicator!.startAnimating()
        }
    }
    func hideProgressBG()
    {
        if progressBGImg != nil
        {
            progressBGImg!.isHidden = true
            progressIndicator!.stopAnimating()
        }
    }
    
}
