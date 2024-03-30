//
//  SignUpViewController.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    
    var states: [String] = []
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statePickerView.dataSource = self
        statePickerView.delegate = self
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
                
        fetchStates()
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === statePickerView {
            return states.count
        } else {
            return cities.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === statePickerView {
            return states[row]
        } else {
            return cities[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView === statePickerView {
                let selectedState = states[row]
                fetchCities(forState: selectedState)
                cityPickerView.isHidden = selectedState.isEmpty
            }
        }
    
    func fetchStates() {
            let baseURL = "http://api.geonames.org"
            let username = "devchelsea"
            let urlString = "\(baseURL)/childrenJSON?geonameId=6252001&username=\(username)&featureCode=ADM1"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let geonames = json?["geonames"] as? [[String: Any]] {
                        let stateNames = geonames.compactMap { $0["adminName1"] as? String }
                        // Update states array on the main thread
                        DispatchQueue.main.async {
                            self?.states = stateNames
                            self?.statePickerView.reloadAllComponents()
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
            task.resume()
    }
    
    func fetchCities(forState state: String) {
        let baseURL = "http://api.geonames.org"
            let username = "devchelsea"
            let escapedState = state.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "\(baseURL)/searchJSON?q=\(escapedState)&maxRows=1000&username=\(username)"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let geonames = json?["geonames"] as? [[String: Any]] {
                        let cityNames = geonames.compactMap { $0["name"] as? String }
                        // Update cities array on the main thread
                        DispatchQueue.main.async {
                            self?.cities = cityNames
                            // Reload cityPickerView to reflect the changes
                            self?.cityPickerView.reloadAllComponents()
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
            task.resume()
    }



     @IBAction func onSignUpTapped(_ sender: Any) {
         guard let username = usernameField.text,
               let email = emailField.text,
               let password = passwordField.text,
               let address = addressField.text,
               !username.isEmpty,
               !email.isEmpty,
               !password.isEmpty,
               !address.isEmpty else {

             showMissingFieldsAlert()
             return
         }

         var newUser = User()
         newUser.username = username
         newUser.email = email
         newUser.password = password
         newUser.address = address

         newUser.signup { [weak self] result in

             switch result {
             case .success(let user):

                 print("✅ Successfully signed up user \(user)")

                 NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

             case .failure(let error):
                 self?.showAlert(description: error.localizedDescription)
             }
         }

     }

     private func showMissingFieldsAlert() {
         let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .default)
         alertController.addAction(action)
         present(alertController, animated: true)
     }

}
