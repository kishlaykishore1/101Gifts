//
//  AppDelegate.swift
//  Gifts-iOS
//
//  Created by angrej singh on 23/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSPlacesClient.provideAPIKey("AIzaSyDSo7bQFKcGAj4aZ0LPgrM-0cbbIOndjVs")
        if MemberModel.getMemberModel() != nil {
            isUserLogin(true)
        } else {
            isUserLogin(false)
        }
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension AppDelegate {
    //Check User Login
    func isUserLogin(_ isLogin: Bool) {
        if isLogin {
            let deshboardVC = StoryBoard.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.window?.rootViewController =  UINavigationController(rootViewController: deshboardVC)
            self.window?.makeKeyAndVisible()
        } else {
            let welcomeVC = StoryBoard.Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.window?.rootViewController = UINavigationController(rootViewController: welcomeVC)
            self.window?.makeKeyAndVisible()
        }
    }
}
