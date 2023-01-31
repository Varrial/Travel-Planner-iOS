import Foundation

struct Trip: Codable{
    
    var destination: String
    var country: String
    var startDate: Date
    var endDate: Date
    var itinerary: Dictionary<String, Array<DayEvent>>
    var budget: Dictionary<String, Array<BudgetItem>>
    var totalBudget: Double
    var packingList: Array<PackingItem>
    var imageURL: String
    
    
    static func loadSampleData() -> [Trip]{
        let trips = [Trip(destination: "", country: "", startDate: Date(), endDate: Date(), itinerary: [:], budget: [:], totalBudget: 0.0, packingList: [], imageURL: "")]
       return trips
        
    }
        
    static func getArchiveURL() -> URL {
        let plistName = "trips"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }

    static func saveToFile(trips: [Trip]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        //let encodedFriends = try? propertyListEncoder.encode(trips)
        let encodedTrips = try? propertyListEncoder.encode(trips)
        try? encodedTrips?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromFile() -> [Trip]? {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedTripsData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedTrips = try? propertyListDecoder.decode(Array<Trip>.self, from: retrievedTripsData) else { return nil }
        return decodedTrips
    }
    
}
