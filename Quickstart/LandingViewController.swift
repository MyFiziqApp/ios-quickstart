//
//  LandingViewController.swift
//  Quickstart

import UIKit

class LandingViewController: UIViewController {

    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // Label will display the launch message
    lazy var welcomeLabel: UILabel = {
        let ul = UILabel()
        // Set the label text
        ul.text = "Welcome to MYQ"
        // Set the label color
        ul.textColor = .orange
        // Set the label font to be bigger and bold
        ul.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // Set the text to be in the center of the label
        ul.textAlignment = .center
        // Set number of lines to 0 so that if the text is wider than the view, it can create a new line.
        ul.numberOfLines = 0
        // Ensure that the words are not clipped but instead drop to a new line.
        ul.lineBreakMode = .byWordWrapping
        // Return the new label.
        return ul
    }()
    
    // Label will display the launch message
    lazy var loginLabel: UILabel = {
        let ul = UILabel()
        // Set the label text
        ul.text = "Do you have an account? Then the Login button below is the one for you!"
        // Set the label color
        ul.textColor = .black
        // Set the label font to be bigger and bold
        ul.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        // Set the text to be in the center of the label
        ul.textAlignment = .center
        // Set number of lines to 0 so that if the text is wider than the view, it can create a new line.
        ul.numberOfLines = 0
        // Ensure that the words are not clipped but instead drop to a new line.
        ul.lineBreakMode = .byWordWrapping
        // Return the new label.
        return ul
    }()
    
    // Label will display the launch message
    lazy var registrationLabel: UILabel = {
        let ul = UILabel()
        // Set the label text
        ul.text = "If you don't have an account yet, you can create one. Just a tap the Register button."
        // Set the label color
        ul.textColor = .black
        // Set the label font to be bigger and bold
        ul.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        // Set the text to be in the center of the label
        ul.textAlignment = .center
        // Set number of lines to 0 so that if the text is wider than the view, it can create a new line.
        ul.numberOfLines = 0
        // Ensure that the words are not clipped but instead drop to a new line.
        ul.lineBreakMode = .byWordWrapping
        // Return the new label.
        return ul
    }()
    
    // Login Button
    lazy var loginButton: UIButton = {
        let ub = UIButton()
        ub.setTitle("Login", for: .normal)
        // Orange color
        ub.backgroundColor = .orange
        // Give it a border to make it feel more button like
        ub.layer.borderWidth = 2.0
        // Set the color of the border to be the same as the button but with an alpha offset
        ub.layer.borderColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        // Set font
        ub.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // Set the Title color
        ub.setTitleColor(.white, for: .normal)
        // Set the action
        ub.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return ub
    }()
    
    // Register Button
    lazy var registerButton: UIButton = {
        let ub = UIButton()
        ub.setTitle("Register", for: .normal)
        // White color
        ub.backgroundColor = .white
        // Give it a border to make it feel more button like
        ub.layer.borderWidth = 2.0
        // Set the color of the border to be the same as the button but with an alpha offset
        ub.layer.borderColor = UIColor.orange.withAlphaComponent(0.5).cgColor
        // Set font
        ub.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // Set the Title color to be the same orange as login button background color
        ub.setTitleColor(.orange, for: .normal)
        // Set the action
        ub.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return ub
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(loginLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(registrationLabel)
        self.view.addSubview(registerButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            hasSetConstraints = true
            self.welcomeLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16.0)
            self.welcomeLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 16.0)
            self.welcomeLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 16.0)
            // Set login and registration button constraints
            // Because the isLoginButton parameter is default of true, we do not need to pass in a parameter for it
            self.setButtonConstraints(forButton: loginButton)
            // Because this is the registration button, we need to pass in false for the parameter.
            self.setButtonConstraints(forButton: registerButton, isLoginButton: false)
            // Set the label constraints
            self.setLabelConstraints(forLabel: loginLabel, aboveButton: loginButton)
            self.setLabelConstraints(forLabel: registrationLabel, aboveButton: registerButton)
        }
    }
    
    // Once again, we follow the DRY principle, and implement a single method to handle the setting of constraints,
    // this time for our labels and they are going to be pinned to the top of their respective buttons.
    private func setLabelConstraints(forLabel label: UILabel, aboveButton button: UIButton) {
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 16.0)
        label.autoPinEdge(.bottom, to: .top, of: button, withOffset: -16.0)
    }
    
    private func setButtonConstraints(forButton button: UIButton, isLoginButton: Bool! = true) {
        button.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
        button.autoPinEdge(toSuperviewEdge: .right, withInset: 16.0)
        button.autoSetDimension(.height, toSize: 60.0)
        // Determines how far off center the buttons should be.
        // The center of the view is equal to 0.0 so a negative CGFloat means it will be closer to the top of the view while positive number means
        // closer to the bottom.
        let centerOffset: CGFloat = isLoginButton ? -100.0 : 100.0
        button.autoAlignAxis(.horizontal, toSameAxisOf: self.view, withOffset: centerOffset)
    }
    
    private func presentLoginRegisterView(shouldDisplayLogin displayLogin: Bool! = true) {
        // Create an instance of the LoginRegisterViewController
        let loginViewController = LoginRegisterViewController()
        // Set the Bool variable that determines which subview will be displayed.
        loginViewController.shouldDisplayLoginView = displayLogin
        // Present the view controller
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapLoginButton() {
        presentLoginRegisterView()
    }
    
    @IBAction func didTapRegisterButton() {
        presentLoginRegisterView(shouldDisplayLogin: false)
    }

}
