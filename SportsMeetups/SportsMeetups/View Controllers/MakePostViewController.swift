//
//  MakePostViewController.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//

import UIKit
import PhotosUI
import ParseSwift

class MakePostViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateInputField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var sportInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        // TODO: Pt 1 - Present Image picker
        // Create and configure PHPickerViewController
        
        // Create a configuration object
        var config = PHPickerConfiguration()
        
        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images
        
        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current
        
        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1
        
        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)
        
        // Set the picker delegate so we can receive whatever image the user picks.
//        picker.delegate = self
        
        // Present the picker
        present(picker, animated: true)
    }
    
    @IBAction func onShareTapped(_ sender: Any) {
        // Dismiss Keyboard
        view.endEditing(true)
        
        // Create Post object
        var post = Post()
        
        // Set properties
        post.title = titleField.text
        post.date = dateInputField.text
        post.address = addressInput.text
        post.sport = sportInput.text
        
        // Set the user as the current user
        post.user = User.current
        post.state = User.current?.state
        
        // Save post (async)
        post.save { [weak self] result in
            
            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")
                    
                    // TODO: Pt 2 - Update user's last posted date
                    // Get the current user
                    if var currentUser = User.current {
                        
                        // Update the `lastPostedDate` property on the user with the current date.
                        currentUser.lastPostedDate = Date()
                        
                        // Save updates to the user (async)
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")
                                
                                // Switch to the main thread for any UI updates
                                DispatchQueue.main.async {
                                    // Return to previous view controller
                                    self?.navigationController?.popViewController(animated: true)
                                }
                                
                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }
                    
                    
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
            
        }
    }
    
    @IBAction func onTakePhotoTapped(_ sender: Any) {
        // TODO: Pt 2 - Present camera
        // Make sure the user's camera is available
        // NOTE: Camera only available on physical iOS device, not available on simulator.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)

    }

    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }

}
extension MakePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
            picker.dismiss(animated: true)

            // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
            // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
            guard let image = info[.editedImage] as? UIImage else {
                print("❌📷 Unable to get image")
                return
            }
    }
}



