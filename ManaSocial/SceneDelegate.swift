//
//  SceneDelegate.swift
//  ManaSocial
//
//  Created by Mahmoud Abu Obaid on 7/9/20.
//  Copyright © 2020 Mahmoud Abu Obaid. All rights reserved.
//

import UIKit

// Global delegate.
let sceneDelegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

// Common used colors
let redColorError = UIColor( red: 1, green: 50/255, blue: 75/255, alpha: 1 )
let greenColorDone = UIColor( red: 30/255, green: 255/255, blue: 125/255, alpha: 1 )
let blueColorBG = UIColor( red: 45/255, green: 213/255, blue: 255/255, alpha: 1 )
let grayColorLight = UIColor( red: 180/255, green: 180/255, blue: 180/255, alpha: 1 );

// Dynamic font size.
let fontSize12 = UIScreen.main.bounds.width / 31

// Saved user's data
var userData : NSDictionary?


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Animated background image.
    let bgImg = UIImageView()
    
    // Initial target x position which will be used to animate background image.
    var initTargetXBGAnimation : CGFloat = 0.0
    
    // Indicates whether Popup view is displayed or not?
    var isPopupDisplayed = false
    
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Creating imageView to store background image
        bgImg.frame = CGRect( x: 0, y: 0, width: self.window!.bounds.width * 1.688, height: self.window!.bounds.height )
        bgImg.image = UIImage( named: "bgImg.jpg" )
        self.window!.addSubview( bgImg )
        self.window!.makeKeyAndVisible()
        
        // Set initTargetXBGAnimation to the most right end of the image.
        initTargetXBGAnimation = -self.bgImg.bounds.width + self.window!.bounds.width
        
        // Start animating the background.
        animateBG( targetX: initTargetXBGAnimation )
        
        // Check if we have a logged in user already.
        tryToLoadUserLoginData()
    }
    
    func saveUserData(_ json: [String: Any] )
    {
        UserDefaults.standard.set( json, forKey: "userLoginData" )
        loadUserLoginData()
    }
    
    func loadUserLoginData()
    {
        userData = UserDefaults.standard.value( forKey: "userLoginData" ) as? NSDictionary
    }
    
    func tryToLoadUserLoginData()
    {
        self.loadUserLoginData()
        if userData != nil, let id = userData?["id"] as? String
        {
            if !id.isEmpty
            {
                DispatchQueue.main.asyncAfter( deadline: .now() + 0.5 ) { self.goToTabBarController() }
            }
        }
    }
    
    func animateBG( targetX: CGFloat )
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
                                self.animateBG( targetX: nextTargetX )
                            }
                        }
    }
    
    
    func displayPopup( message: String, bgColor: UIColor )
    {
        if isPopupDisplayed
        {
            return
        }
        
        isPopupDisplayed = true
        
        let popupViewHeight = self.window!.bounds.height / 14.2
        let popupViewY = 0 - popupViewHeight

        let popupView = UIView( frame: CGRect( x: 0, y: popupViewY, width: self.window!.bounds.width, height: popupViewHeight ) )
        popupView.backgroundColor = bgColor
        self.window!.addSubview( popupView )
        
        
        let msgLabelWidth = popupView.bounds.width
        let appHeight = self.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let msgLabelHeight = popupView.bounds.height + appHeight / 2
        
        let popupLabel = UILabel()
        popupLabel.frame.size.width = msgLabelWidth
        popupLabel.frame.size.height = msgLabelHeight
        popupLabel.numberOfLines = 0
        popupLabel.text = message
        popupLabel.font = UIFont( name: "HelveticaNeue", size: fontSize12 )
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
                            }
                        }
                    )
                }
            } )
    }
    
    
    func goToTabBarController()
    {
        let storyboard = UIStoryboard( name: "Main", bundle: nil )
        let tabBarC = storyboard.instantiateViewController( identifier: "tabBarC" )
        window?.rootViewController = tabBarC
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

