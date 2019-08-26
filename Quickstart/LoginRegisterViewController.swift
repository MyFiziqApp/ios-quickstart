//
//  LoginRegisterViewController.swift
//  Quickstart

import UIKit
import MyFiziqSDKLoginView

class LoginRegisterViewController: UIViewController {
    
    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // Public flag that can be set to determine which subview will be displayed when this view controller is shown.
    public var shouldDisplayLoginView: Bool = true
    
    // MARK - View Elements
    
    // The Login view is a UIView subclass which contains all the elements required by the Login View.
    private lazy var loginView: MyFiziqLoginView = {
        let uv = MyFiziqLoginView()
        // Ensure the delegate is set to true to receive successful and failed login attempts.
        uv.loginDelegate = self
        // Return the login view
        return uv
    }()
    
    private lazy var joinView: MyFiziqJoinView = {
        let uv = MyFiziqJoinView()
        // Ensure the delegate is set to true to receive successful and failed login attempts.
        uv.loginDelegate = self
        // Return the join view.
        return uv
    }()
    
    // MARK - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(loginView)
        self.view.addSubview(joinView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsUpdateConstraints()
        // Show or hide the view according to display option
        self.loginView.isHidden = !shouldDisplayLoginView
        self.joinView.isHidden = shouldDisplayLoginView
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            self.hasSetConstraints = true
            // Both the join and login view require being pinned to the **SAFE** view area, not super view area.
            // This is because devices with notches (iPhone X, Xs, etc.) would have the views go into the notched area, so there is an important distinction.
            self.loginView.autoPinEdgesToSuperviewSafeArea()
            self.joinView.autoPinEdgesToSuperviewSafeArea()
        }
    }
    
}

extension LoginRegisterViewController: MyFiziqLoginViewDelegate {
    
    func loginHeaderState() -> MyFiziqLoginHeaderState {
        // Default will not show the navigation and title view for the Login and Regiration views, which require the app
        // to handle the modal transitions. However, the MyFiziq Login SDK provides a helpful navigation option should
        // a rapid development option be used.
        return .navigation
    }
    
    func successLogin() {
        self.removeControllerFromStack {
            self.redirectUserToView(forUserStateLoggedIn: true)
        }
    }
    
    func didTapBackButton() {
        // If there is a navigation controller, pop this one and return to the root navigation controller.
        if let navController = self.navigationController {
            navController.popToRootViewController(animated: true)
        } else {
            // Else dismiss this view controller.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
