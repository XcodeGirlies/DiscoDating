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
import MapKit

class PostCell: UITableViewCell {
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var imageDataRequest: DataRequest?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        if let user = post.user {
            usernameLabel.text = user.username
        }
        // Convert address to coordinates
        if let address = post.address {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
                guard let self = self else { return }
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                if let placemark = placemarks?.first {
                    let coordinate = placemark.location?.coordinate
                    // Add a pin to the map
                    if let coordinate = coordinate {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = post.title
                        self.mapView.addAnnotation(annotation)
                        // Zoom to the region
                        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
        }

        titleEvent.text = post.title
        dateLabel.text = post.date
        sportLabel.text = post.sport
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageDataRequest?.cancel()
        // Remove any existing annotations before reusing the cell
        mapView.removeAnnotations(mapView.annotations)
    }
    
}


