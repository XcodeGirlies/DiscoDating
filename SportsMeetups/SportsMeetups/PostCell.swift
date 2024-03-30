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
// initialize usernameLabel
// initialize dateLabel
// initialize postImageView
// initialize captionLabel
    
// private var imageDataRequest: DataRequest?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    func configure(with post: Post) {
        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt,
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {
            blurView.isHidden = abs(diffHours) < 24
        } else {
            blurView.isHidden = false
        }

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
        
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageDataRequest?.cancel()
    }
    */
    
}


