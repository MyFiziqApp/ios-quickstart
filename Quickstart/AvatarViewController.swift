//
//  AvatarViewController.swift
//  Quickstart

import UIKit
import MyFiziqSDK
import MyFiziqSDKCommon
import PureLayout

class AvatarViewController: UIViewController {
    
    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // Keep track of if the avatar is rotating
    private var avatarIsRotating: Bool = false
    
    public var avatar: MyFiziqAvatar?
    
    // Container view for the buttons.
    private lazy var buttonContainerView: UIView = {
        let uv = UIView()
        // Add a border to the button view
        uv.layer.borderColor = UIColor.orange.cgColor
        uv.layer.borderWidth = 1.0
        return uv
    }()
    
    // Rotate Avatar button
    private lazy var rotateAvatarButton: UIButton = {
        let ub = UIButton()
        ub.setTitle("Spin", for: .normal)
        // White color
        ub.backgroundColor = .white
        // Set font
        ub.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // Set the Title color to be the same orange as login button background color
        ub.setTitleColor(.orange, for: .normal)
        // Set the action
        ub.addTarget(self, action: #selector(didTapRotateAvatar), for: .touchUpInside)
        return ub
    }()
    
    // Rotate Avatar button
    private lazy var resetAvatarPositionButton: UIButton = {
        let ub = UIButton()
        ub.setTitle("Reset", for: .normal)
        // White color
        ub.backgroundColor = .white
        // Set font
        ub.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        // Set the Title color to be the same orange as login button background color
        ub.setTitleColor(.orange, for: .normal)
        // Set the action
        ub.addTarget(self, action: #selector(didTapResetAvatar), for: .touchUpInside)
        return ub
    }()
    
    // The mesh view to display a completed MyFiziq avatar mesh
    private lazy var avatarMeshView: MyFiziqCommonMeshView = {
        let uv = MyFiziqCommonMeshView()
        return uv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Set the default title
        self.title = "Avatar"
        // Set the navigation controller bar to use large titles for modern iOS product look
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Add the mesh view
        self.view.addSubview(avatarMeshView)
        // Add button container view
        self.view.addSubview(buttonContainerView)
        // Add the buttons to the container view
        buttonContainerView.addSubview(rotateAvatarButton)
        buttonContainerView.addSubview(resetAvatarPositionButton)
        // Set the constraints
        self.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If there is an avatar result, set the mesh view avatar
        if let avatarResult = avatar {
            // Delay the load of the avatar to ensure mesh view is prepared for display
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.avatarMeshView.setAvatar(avatarResult)
                self.didTapResetAvatar()
            }
            // Set the title to be the completion date
            self.title = avatarResult.completedDate?.toString()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            hasSetConstraints = true
            // Pin the avatarMeshView to the safe area.
            self.avatarMeshView.autoPinEdge(toSuperviewSafeArea: .top)
            self.avatarMeshView.autoPinEdge(toSuperviewSafeArea: .left)
            self.avatarMeshView.autoPinEdge(toSuperviewSafeArea: .right)
            // Pin the bottom of the avatar mesh view to the top of button container view
            self.avatarMeshView.autoPinEdge(.bottom, to: .top, of: buttonContainerView)
            // Pin the button container view to the bottom left and right edges
            self.buttonContainerView.autoPinEdge(toSuperviewSafeArea: .bottom)
            self.buttonContainerView.autoPinEdge(toSuperviewSafeArea: .left)
            self.buttonContainerView.autoPinEdge(toSuperviewSafeArea: .right)
            // Set the height of the container to a fixed size of 60.0
            self.buttonContainerView.autoSetDimension(.height, toSize: 60.0)
            // Following the DRY principles set the button constraints.
            self.setConstraints(forButton: resetAvatarPositionButton, withLeadingEdge: .left)
            self.setConstraints(forButton: rotateAvatarButton, withLeadingEdge: .right)
        }
    }
    
    // Prevent repeating code to achieve the same thing on the buttons by setting their constraints according to the edge they're pinned to.
    private func setConstraints(forButton button: UIButton, withLeadingEdge edge: ALEdge) {
        // Set the width of the button to be equal - 50% of the container view
        button.autoMatch(.width, to: .width, of: self.buttonContainerView, withMultiplier: 0.5)
        // Pin the button to the top and bottom of the container view (which is it's super view)
        button.autoPinEdge(toSuperviewEdge: .top)
        button.autoPinEdge(toSuperviewEdge: .bottom)
        // Pin the button left/right edge according to the edge passed in.
        button.autoPinEdge(toSuperviewEdge: edge)
    }
    
    // Control the display state of the rotate button to reflect the state of the avatar.
    private func rotateButtonState() {
        // If avatar is rotating, change the button title to pause, else keep it as rotate
        let title = avatarIsRotating ? "Stop" : "Spin"
        // Control the title and background color according to the state.
        let titleColor: UIColor = avatarIsRotating ? .white : .orange
        let backgroundColor: UIColor = !avatarIsRotating ? .white : .orange
        rotateAvatarButton.setTitle(title, for: .normal)
        rotateAvatarButton.setTitleColor(titleColor, for: .normal)
        rotateAvatarButton.backgroundColor = backgroundColor
    }
    
    // MARK: - Actions
    
    // Rotate or pause the rotation of the avatar.
    @IBAction private func didTapRotateAvatar() {
        avatarIsRotating = !avatarIsRotating
        avatarMeshView.setAutoRotate(avatarIsRotating)
        rotateButtonState()
    }
    
    // Reset the avatar position.
    @IBAction private func didTapResetAvatar() {
        avatarIsRotating = false
        avatarMeshView.setAutoRotate(avatarIsRotating)
        avatarMeshView.setMeshToInitialPerspectiveWithAnimation(true)
        rotateButtonState()
    }

}
