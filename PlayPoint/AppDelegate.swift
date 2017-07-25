//
//  AppDelegate.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 26/04/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var shared = AppDelegate()
    
    let tabBarControllerIdentifier = "TabBarController"
    let loginControllerIdentifier  = "LoginController"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        self.configurarAparenciaGlobal()
        self.configurarControllerInicial()
        
        return true
    }
    
    func usuarioAutenticadoComFacebook() -> Bool {
        
        return FBSDKAccessToken.current() != nil
        
    }
    
    func configurarAparenciaGlobal() {
        
        
        
    }
    
    func configurarControllerInicial() {
        
        self.window       = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboad = UIStoryboard(name: "Main", bundle: nil)
        var controller: UIViewController?

        
        controller = mainStoryboad.instantiateViewController(withIdentifier: usuarioAutenticadoComFacebook() ? tabBarControllerIdentifier : loginControllerIdentifier);
        
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func logOut()  {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let mainStoryboad               = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = mainStoryboad.instantiateViewController(withIdentifier: self.loginControllerIdentifier)
        }, completion: nil)
        
    

    }
}

