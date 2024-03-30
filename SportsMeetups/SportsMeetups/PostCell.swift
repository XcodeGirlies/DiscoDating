//
//  PostCell.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//

import UIKit
import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var captionLabel: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    
    private var imageDataRequest: DataRequest?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        if let user = post.user {
            usernameLabel.text = user.username
        }

        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        captionLabel.text = post.caption
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageDataRequest?.cancel()
    }
    
}


