//
//  MYQLoginHandler.swift
//  Quickstart

import Foundation
import MyFiziqSDKLoginView

class MYQLoginHandler: NSObject {
    
    // MARK: - Private Variables and Methods
    
    // Completion handler which is assigned on registration func call.
    // The completion handler is a simple object which is designed to enable the developer to handle success and fail events.
    private var completionHandler: ((Bool, Error?) -> Void)?
    
    // Your private credentials which will need to be obtained from MyFiziq.
    // If you do not have them, please contact admin@myfiziq.com or support@myfiziq.com
    private var credentials: [String: String] {
        return [
            MFZSdkSetupKey: "[ Your Client ID or Setup Key ]",
            MFZSdkSetupSecret: "[ Your secret token ]",
            MFZSdkSetupEnvironment: "[ Your environment ]"
        ]
    }
    
    // MARK: - Public Methods
    
    // Register the app with MyFiziq SDK. This will validate your MyFiziq credentials at the beginning of each session.
    public func registerApp(withCompletionHandler handler: @escaping ((Bool, Error?) -> Void)) {
        self.completionHandler = handler
        MyFiziqLogin.shared()?.myfiziqCredentials = credentials
        MyFiziqLogin.shared()?.loginDelegate = self
        MyFiziqLogin.shared()?.reloadMyFiziqSDK()
    }
    
}

extension MYQLoginHandler: MyFiziqLoginDelegate {
    
    func myfiziqIsReadyAndUserLogged(in isLoggedIn: Bool) {
        if let handler = self.completionHandler {
            handler(isLoggedIn, nil)
        }
    }
    
    func myfiziqSetupFailedWithError(_ error: Error?) {
        if let anError = error {
            print("Error setting up sdk: \(anError)")
        }
        if let handler = self.completionHandler {
            handler(false, error)
        }
    }
    
}
