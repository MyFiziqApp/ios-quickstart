//
//  InputViewController.swift
//  Quickstart

import UIKit
import MyFiziqSDKInputView

class InputViewController: UIViewController {
    
    // MARK: - Variables
    
    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // MyFiziq Input View contains all the elemnts required to create valid MyFiziq input to begin creating a new avatar.
    private lazy var myfiziqInputView: MyFiziqInputView = {
        let uv = MyFiziqInputView()
        // The Input View has a delegate and datasource to set and receive information.
        uv.delegate = self
        uv.datasource = self
        return uv
    }()
    
    private lazy var myfiziqActivityIndicator: MyFiziqCommonSpinnerDelegate? = {
        let uv = QuickstartCommon.shared()?.spinner(to: self.view)
        return uv
    }()
    
    private func shouldShowActivityIndicator(show: Bool) {
        // Always ensure anything associated with display of UI elements is on the main thread.
        OperationQueue.main.addOperation {
            if show {
                self.myfiziqActivityIndicator?.show()
            } else {
                self.myfiziqActivityIndicator?.hide()
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view background color
        self.view.backgroundColor = .white
        // Set the view title
        self.title = "New Avatar"
        // Set the navigation controller bar to use large titles for modern iOS product look
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Add the subviews
        self.view.addSubview(myfiziqInputView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            hasSetConstraints = true
            self.myfiziqInputView.autoPinEdgesToSuperviewSafeArea()
        }
    }
    
    private func initiateCreateAvatar() {
        OperationQueue.main.addOperation {
            // The MyFiziq avatar creation process is handled entirely by the MyFiziqSDK, so we pass the baton of view control to it until it returns.
            MyFiziqSDK.shared()?.initiateAvatarCreation(options: nil, withMiscellaneousData: nil, from: self, completion: { (error) in
                // Once the SDK has completed operation - captured a users measurements OR the user chose to exit, check for error.
                self.shouldShowActivityIndicator(show: false)
                if let anError = error {
                    // Handle the error
                    print("There was an error creating the avatar : \(anError)")
                    return
                }
                // If the avatar process was a success, dismiss the view.
                self.removeControllerFromStack {
                    // Completed the process.
                }
            })
        }
    }
    
}

extension InputViewController: MyFiziqInputViewDelegate, MyFiziqInputViewDataSource {
    
    // MARK: - MyFiziqInputView Data Source
    
    func inputTitle() -> String? {
        return "New MyFiziq Avatar"
    }
    
    func inputGender() -> MFZGender {
        if let myq = MyFiziqSDK.shared() {
            return myq.user.gender
        }
        return .male
    }
    
    func inputHeightCM() -> Double {
        if let myq = MyFiziqSDK.shared() {
            return Double(myq.user.heightInCm)
        }
        return 0.0
    }
    
    func inputWeightKG() -> Double {
        if let myq = MyFiziqSDK.shared() {
            return Double(myq.user.weightInKg)
        }
        return 0.0
    }
    
    // MARK: - MyFiziqInputView Delegate
    
    func didCompleteInput(withValues values: [MyFiziqCommonPickerValueDelegate]) {
        self.shouldShowActivityIndicator(show: true)
        // Update the users info
        MyFiziqSDK.shared()?.user.gender = myfiziqInputView.getGender()
        if let inputHeight = myfiziqInputView.getHeight(), let inputWeight = myfiziqInputView.getWeight() {
            MyFiziqSDK.shared()?.user.heightInCm = Float(inputHeight.getHeightCM())
            MyFiziqSDK.shared()?.user.weightInKg = Float(inputWeight.getWeightKG())
        }
        // Call the user object to update the user information.
        MyFiziqSDK.shared()?.user.updateDetails { (error) in
            // If the update failed, return.
            if let anError = error {
                // Handle the error
                print("There was an error updating the users information: \(anError)")
                self.shouldShowActivityIndicator(show: false)
                return
            }
            // Initiate create avatar
            self.initiateCreateAvatar()
        }
    }
    
}
