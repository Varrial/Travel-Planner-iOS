//
//  TripCollectionViewCell.swift
//  Travel app - swift accelerator 2020 grup 7
//
//  Created by Sonia Becz on 25/01/2023.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var datesView: UIView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var trip: Trip! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let trip = trip {
            destinationImageView.loadFrom(URLAddress: trip.imageURL)
            destinationLabel.text = trip.destination
            countryLabel.text = trip.country
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            let sDate = formatter.string(from: trip.startDate)
            let eDate = formatter.string(from: trip.endDate)
            datesLabel.text = "\(sDate) - \(eDate)"
        } else {
            destinationImageView.image = nil
            destinationLabel.text = nil
            countryLabel.text = nil
            datesLabel.text = nil
        }
        
        destinationImageView.layer.cornerRadius = 25.0
        destinationImageView.layer.masksToBounds = true
        datesView.layer.cornerRadius = 5.0
        datesView.layer.masksToBounds = true
        placeView.layer.cornerRadius = 25.0
        placeView.layer.masksToBounds = true
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
