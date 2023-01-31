import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY:String! = "4bfada23cf7be386b75bcf03b3586539"
let EXTRAS:String! = "url_c"
let DATA_FORMAT:String! = "json"
let CONTENT_TYPE:String!="1"
let NO_JSON_CALLBACK:String! = "1"
let TAG_MODE:String!="all"
let SORT:String!="relevance"
let IS_GETTY:String!="true"


class NewTripTableViewController: UITableViewController {
    var trip: Trip! = nil
    var photos = [[String: AnyObject]]()
    var imageURL: String!

    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var image: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func backToMain(_sender: Any) {
        FlickrAPI.searchPhotos(text: destinationTextField.text! + "," + countryTextField.text!) { (photosArray, error) in
            self.photos = photosArray
            print(self.photos.count)
            DispatchQueue.main.sync { [self] in
                let photoDict = self.photos[0]
                
                if let imageUrlString = photoDict["url_c"] as? String
                {
                    print(imageUrlString)
                    self.imageURL = imageUrlString
                    trip = Trip(destination: destinationTextField.text ?? "" ,country: countryTextField.text ?? "" ,startDate: startDatePicker.date, endDate: endDatePicker.date, itinerary: [:], budget: [:], totalBudget: 0.0, packingList: [], imageURL: imageUrlString)
                    performSegue(withIdentifier: "unwindSave", sender: self)
                    
                } else {
                    print("FAIL")
                }
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSave"{
        if segue.destination is TripViewController{
            
            print("Almost There")

            
        }
    }
}

    
    @IBAction func destinationEditingEnd(_ sender: Any) {
        destinationTextField.resignFirstResponder()
    }
    

}
