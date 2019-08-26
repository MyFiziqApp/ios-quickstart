//
//  AppDelegate.swift
//  Quickstart

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func registerAppAndCheckLoggedInState() {
        // Create an instance of the MYQLoginHandler
        let loginHandler = MYQLoginHandler()
        // Call the registerApp method in the LoginHandler class
        // Pass in the handlerLogin method which has properties for handling Bool and Error
        loginHandler.registerApp(withCompletionHandler: self.handlerLogin(isLoggedIn:error:))
    }
    
    @objc public func handlerLogin(isLoggedIn: Bool, error: Error?) {
        if isLoggedIn {
            // Create a navigation controller with the home view as the root view.
            // The home view controller requires a navigation controller so that button items can be set in the top of the view
            let navController = UINavigationController(rootViewController: HomeViewController())
            openView(withController: navController)
        } else {
            print("Oh no, not logged in.")
            if let anError = error {
                print("There was an error setting up your app with MyFiziq. Checkout this error: \(anError)")
            } else {
                openView(withController: LandingViewController())
            }
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    private func openView(withController controller: UIViewController) {
        if let vc = getTopMostViewController() {
            vc.present(controller, animated: true, completion: nil)
        } else {
            self.window?.rootViewController?.present(controller, animated: true, completion: nil)
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerAppAndCheckLoggedInState()
        return true
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


}

