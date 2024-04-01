//
//  ProfileViewController.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//
import Foundation
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = DataManager.shared.currentUser
        
        usernameLabel.text = user.username
        emailLabel.text = "Email: " + (user.email ?? "")
        addressLabel.text = "Address: " + (user.address ?? "") + " " + (user.city ?? "") + ", " + (user.state ?? "")
        
        let sportsArray = user.sports
        let sportsString = sportsArray?.joined(separator: ", ")
        sportsLabel.text = "Sports interested in: " + (sportsString ?? "")
    }

    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}
