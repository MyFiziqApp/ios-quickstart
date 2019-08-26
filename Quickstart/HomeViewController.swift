//
//  HomeViewController.swift
//  Quickstart

import UIKit
import MyFiziqSDK
import MyFiziqSDKLoginView

class HomeViewController: UIViewController {
    
    // Constraints set flag
    private var hasSetConstraints: Bool = false
    
    // We will be displaying avatar results in a table view.
    private lazy var tableView: UITableView = {
        // Create a table view instance
        let ut = UITableView(frame: .zero, style: .plain)
        // Ensure the delegate and datasource are set to self
        ut.delegate = self
        ut.dataSource = self
        // Ensure that you register a class of table view cell to display dat, especially when dequeueing cells.
        ut.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        // Return the new table view.
        return ut
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the background color
        self.view.backgroundColor = .white
        // Set the title of the view
        self.title = "Avatars"
        // Set the navigation controller bar to use large titles for modern iOS product look
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Add the subviews
        self.view.addSubview(tableView)
        // Set the left navigation bar button to be logout
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        // Button to create an avatar
        let barButtonItemOne = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapCreateAvatar))
        // Button to refresh the table view
        let barButtonItemTwo = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefreshTableView))
        // Set the right navigation bar buttons
        self.navigationItem.rightBarButtonItems = [barButtonItemOne, barButtonItemTwo]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViewConstraints()
        didTapRefreshTableView()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !hasSetConstraints {
            hasSetConstraints = true
            // Pin the table view to the super view edges.
            tableView.autoPinEdgesToSuperviewSafeArea()
        }
    }
    
    @IBAction private func didTapLogout() {
        self.shouldShowActivityIndicator(show: true)
        // Create an instance of login sdk
        if let loginSDK = MyFiziqLogin.shared() {
            // Call to log user out
            loginSDK.userLogout { (error) in
                self.shouldShowActivityIndicator(show: false)
                // If no error, return to landing page
                if error == nil {
                    // Our extension method will dismiss this view
                    self.removeControllerFromStack {
                        // On completion of the method, we will redirect the user using the app delegate method.
                        self.redirectUserToView(forUserStateLoggedIn: false)
                    }
                }
            }
        }
    }
    
    // Call the MyFiziq SDK endpoint to get all available avatars and refresh the list of avatars if successful.
    @IBAction private func didTapRefreshTableView() {
        self.shouldShowActivityIndicator(show: true)
        // On success reload the table view
        MyFiziqSDK.shared()?.avatars.requestAvatars(success: {
            self.shouldShowActivityIndicator(show: false)
            self.tableView.reloadData()
        }) { (error) in
            self.shouldShowActivityIndicator(show: false)
            // If an error occurred, find out why. Handle errors your own way.
            if let anError = error {
                print("There was an error fetching the avatars. \(anError)")
            }
        }
    }
    
    @IBAction private func didTapCreateAvatar() {
        // Add the InputViewController to the navigation controller stack.
        // We know that a navigation controller exists because we created it in the AppDelegate.
        self.navigationController?.pushViewController(InputViewController(), animated: true)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyFiziqSDK.shared()?.avatars.all.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        // Set the cell style to be subtitle
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "UITableViewCell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        if let avatar = MyFiziqSDK.shared()?.avatars.all[indexPath.row] {
            cell.textLabel?.text = avatar.attemptId
            switch avatar.state {
            case .unknown:
                cell.detailTextLabel?.text = "Unknown"
                cell.detailTextLabel?.textColor = .green
                break
            case .processing:
                cell.detailTextLabel?.text = "Processing - requested on \(avatar.requestDate?.toString() ?? "UNKNOWN")"
                cell.detailTextLabel?.textColor = .gray
                break
            case .completed:
                cell.detailTextLabel?.text = "Completed on \(avatar.completedDate?.toString() ?? "UNKNOWN")"
                cell.detailTextLabel?.textColor = .orange
                break
            case .failed:
                cell.detailTextLabel?.text = "Failed"
                cell.detailTextLabel?.textColor = .red
                break
            @unknown default:
                cell.detailTextLabel?.text = "Unknown"
                cell.detailTextLabel?.textColor = .purple
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected avatar result
        // If the result is not complete, do not proceed
        if let avatarResult = MyFiziqSDK.shared()?.avatars.all[indexPath.row] {
            if avatarResult.state != .completed {
                print("This avatar is not completed yet.")
                return
            }
            // Create an instance of the avatar view controller
            let avatarController = AvatarViewController()
            // Set the avatar
            avatarController.avatar = avatarResult
            // Show the avatar controller
            self.navigationController?.show(avatarController, sender: self)
        }
    }
}

extension Date {
    // By default the value for format is "dd MMM yyyy"
    func toString(dateFormat format: String! = "dd MMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UIViewController {
    
    func removeControllerFromStack(withCompletion completion: @escaping (() -> Void)) {
        OperationQueue.main.addOperation {
            // If the view has a navigation controller, we need to ensure we remove it from the stack.
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: false)
                navController.removeFromParent()
                completion()
            } else {
                // Other wise, we remove this view from the stack by calling dismiss on self, and then launch home screen on completion.
                self.dismiss(animated: false) {
                    completion()
                }
            }
        }
    }
    
    func redirectUserToView(forUserStateLoggedIn isLoggedIn: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.handlerLogin(isLoggedIn: isLoggedIn, error: nil)
        }
    }
    
}
