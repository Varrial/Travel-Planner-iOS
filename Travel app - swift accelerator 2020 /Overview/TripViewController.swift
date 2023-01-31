//
//  TripViewController.swift
//  Travel app - swift accelerator 2020 grup 7
//
//  Created by Sonia Becz on 25/01/2023.
//

import UIKit

class TripViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    var trips: Array<Trip> = []
    let cellScaleX: CGFloat = 0.75
    let cellScaleY: CGFloat = 0.6
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaleX)
        let cellHeight = floor(screenSize.height * cellScaleY)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.isUserInteractionEnabled = true;
        
        
        if let loadedTrips = Trip.loadFromFile(){
            print("File founded. Loading trips.")
            trips = loadedTrips
        }else{
            print("No trips! Make some.")
       //     trips = Trip.loadSampleData()
        }
        
        profilePicture.layer.cornerRadius = 22.0
        profilePicture.layer.masksToBounds = true
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview"{
            if let navigationVC = segue.destination as? UINavigationController{
                if let dest = navigationVC.topViewController as? TripOverviewViewController{
                    if self.trips.isEmpty == false {
                        dest.tripNo = (collectionView.indexPathsForSelectedItems?.first!.item)!
                        print("DID THAT" + String((collectionView.indexPathsForSelectedItems?.first!.item)!))
                        dest.trip = trips[((collectionView.indexPathsForSelectedItems?.first!.item)!)]
                        dest.trips = trips
                    }
                }
            }
        }
    }
    
    @IBAction func backFromNewTrip(for segue: UIStoryboardSegue){
        if let source = segue.source as? NewTripTableViewController{

            print("HERE")
            if source.trip != nil {
                trips.insert(source.trip, at: 0)
                print("backFromNewTrip", trips)
                collectionView.reloadData()
            }
            Trip.saveToFile(trips: trips)
        }

    }
    
    @IBAction func backFromOverview(for segue: UIStoryboardSegue){
        if let source = segue.source as? TripOverviewViewController{
            trips = source.trips
            Trip.saveToFile(trips: trips)
            
        }

    }
    
}




extension TripViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionViewCell", for: indexPath) as! TripCollectionViewCell
        let trip = trips[indexPath.item]
        
        cell.trip = trip
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = trips[indexPath.item]
        print(selectedData)
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
      
}

extension TripViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left)/cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
        
    }
    
}


