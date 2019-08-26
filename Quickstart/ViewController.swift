//
//  ViewController.swift
//  Quickstart

import UIKit
import PureLayout

class ViewController: UIViewController {
    
    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // Label will display the launch message
    private lazy var loadingLabel: UILabel = {
        let ul = UILabel()
        // Set the label text
        ul.text = "Checking MyFiziq Registration."
        // Set the label color
        ul.textColor = .black
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
    
    // MyFiziq offer a loading indicator. It is customizable using the CSS variables. Here, we create a parent view that
    // encapsulates the loading indicator, this is because the indicator is intended to be be applied to a view that
    // is explicitly blocking.
    private lazy var myfiziqActivityIndicator: UIView = {
        let uv = UIView()
        return uv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the subviews to the view
        self.view.addSubview(myfiziqActivityIndicator)
        self.view.addSubview(loadingLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsUpdateConstraints()
    }
    
    // Need to call this method to ensure constraints are set.
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Only set the constraints once and only if false
        if !hasSetConstraints {
            // Set the flag to true
            hasSetConstraints = true
            // Pin the left and right edges of the label to the left and right edges of the view with a small inset of 16.0
            // The height is determined by the font and text. So no need to set a height.
            // If your rotate the device the width of the label dynamically updates to be a constant (self.view.frame.size.width - 16.0 - 16.0) because pinning the edge anchors
            // the label to the left and right sides of the view.
            loadingLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            loadingLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16.0)
            // Center the label in the view. This ensures that no matter what the orientation of your device is, the label is always in the center.
            loadingLabel.autoCenterInSuperview()
            // Set the activity indicator to be pinned to the bottom of the label.
            // This means that no matter the orientation of the view, the loading indicator is always in the same position below the label
            myfiziqActivityIndicator.autoPinEdge(.top, to: .bottom, of: self.loadingLabel, withOffset: 16.0)
            // Give the indicator a fixed size. This means it wont get out of shape in any scenario.
            myfiziqActivityIndicator.autoSetDimensions(to: CGSize(width: 100.0, height: 100.0))
            // Align the label to always be in the middle of the left and right side of the view, while the pinning at the top of the activity indicator view
            myfiziqActivityIndicator.autoAlignAxis(toSuperviewAxis: .vertical)
            // Set the indicator to the encapsulating view.
            if let indicator = QuickstartCommon.shared()?.spinner(to: myfiziqActivityIndicator) {
                indicator.show()
            }
        }
    }


}

