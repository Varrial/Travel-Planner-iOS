import UIKit

class ItinTableViewController:
    UITableViewController {
    
    var delegate: ItinDataDelegate?
    
    var dayNo: Int = 0
    var schedule = ["Mar 22, 2020", "Mar 27, 2020"]
    var interval: Int = 0
    var dayDictionary: Dictionary<Int, Array<DayEvent>> = [:]
    var itinEventsDict: Dictionary<String, Array<DayEvent>> = [:]
    var tempEvent: Array<DayEvent> = []
    var dateArray: Array<String> = []
    
    
    var trips: [Trip] = []
    var tripNo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Itinerary"
        interval = getDateInterval(timeTable: self.schedule)
        dateArray = []
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.printItinEvent(titleDict: dayDictionary)
        
        
        print("viewDidAppear")
        print(dayDictionary)
        print("dateArray", dateArray)
        
        for i in dateArray{
            let day = getDateInterval(timeTable: [dateArray[0], i])
            for (k,_) in self.dayDictionary{
                print("ikik", day, k)
                if (day-1) == k{
                    itinEventsDict[i] = dayDictionary[k]
                }
            }
        }
        print("itinEventsDict", itinEventsDict)
        trips[tripNo].itinerary = itinEventsDict
        Trip.saveToFile(trips: trips)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interval
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath)
        cell.textLabel?.text = "Day \(String(indexPath.row+1))"
        let tempDayNo = generateDate(schedule: self.schedule, dayNumber: indexPath.row)
        cell.detailTextLabel?.text = tempDayNo
        let cellLabelFormatter = DateFormatter()
        cellLabelFormatter.dateFormat = "dd MM yyyy"
        let cellLabelFormatter2 = DateFormatter()
        cellLabelFormatter2.dateFormat = "MMM dd, yyyy"
        let tempDate = cellLabelFormatter2.string(from: cellLabelFormatter.date(from: (cell.detailTextLabel?.text)!) ?? Date())
        
        self.dateArray.append(tempDate)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dayNo = indexPath.row
        performSegue(withIdentifier: "dayToEvents", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayToEvents"{
            let destinationNavigationController = segue.destination as? UINavigationController
            let dest = destinationNavigationController?.topViewController as? ItinEventsTableViewController
            dest?.dateArray = dateArray
            dest?.anotherEventNoForPassingDate = dayNo
            dest?.trips = trips
            dest?.tripNo = tripNo
            dest?.itinEventsDict = itinEventsDict
            switch dayDictionary[dayNo] {
            case nil:
                dest?.events = []
                dest?.dayNo = self.dayNo
            default:
                dest?.events = dayDictionary[dayNo]!
                dest?.dayNo = self.dayNo
            }
        }
    }

    
    func getDateInterval(timeTable: [String]) -> Int{
        print("itinTableVC startDate, date:", timeTable)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let dateStart = formatter.date(from: timeTable[0])!
        let dateEndTemp = formatter.date(from: timeTable[1])!
        let dateEnd = dateEndTemp.addingTimeInterval(TimeInterval(60 * 60 * 24))
        let interval = Int( dateEnd.timeIntervalSince(dateStart)/(24.0*60.0*60.0))
        print("old interval:", interval)
        return interval
    }
    
    func generateDate(schedule: [String], dayNumber: Int) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let dateStart = formatter.date(from: schedule[0])!
        let dateMiddle = dateStart.addingTimeInterval(TimeInterval(dayNumber * 60 * 60 * 24))
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .medium
        formatter2.timeStyle = .none
        let day = formatter2.string(from: dateMiddle)
        
        return day
    }
    
    
    @IBAction func backToItineraryTableViewController(with segue: UIStoryboardSegue){
        
    }
}
