import UIKit

protocol ItinDataDelegate {
    func printItinEvent(titleDict: Dictionary<Int, Any>)
}

protocol PackingListDataDelegate {
    func printPackingListItem(titleArray: Array<PackingItem>, isChecked: Bool)
}

protocol PackingListCheckedDelegate {
    func identify(isChecked: Bool)
}

protocol BudgetDataDelegate {
    func calculateBudget(string1: String, string2: String)
}

class TripOverviewViewController: UIViewController, ItinDataDelegate, PackingListDataDelegate, BudgetDataDelegate{
    
    func calculateBudget(string1: String, string2: String) {
    }
    
    
    
    
    fileprivate func packingListCircleChecking(_ item: PackingItem) {
        print("circle checking")
        packingListOverviewLabel.text = item.name
        packingListCheckCircle.isHidden = false
        for i in packingItemsStorateList{
            if i.name == packingListOverviewLabel.text{
                if i.checked{
                    print("circle checking 1")
                    packingListCheckCircle.setImage(UIImage(named: "checkmark.circle"), for: .normal)
                }else{
                    print("circle checking 2")
                    packingListCheckCircle.setImage(UIImage(named: "circle"), for: .normal)
                }
            }
        }
    }
    

    
    func printPackingListItem(titleArray: Array<PackingItem>, isChecked: Bool) {
    }
    
    
    
    
    func printItinEvent(titleDict: Dictionary<Int, Any>) {
    }
    
    //MARK: general overview variables
    var start: String = ""
    var end: String = ""
    @IBOutlet weak var locationTextField: UITextField!
    var tripNo: Int = 0
    var trip: Trip!
    var newTrip: Bool = true
    var trips: Array<Trip> = []
    var imageURL: String = ""
    var country: String = ""
    
    @IBOutlet weak var newItineraryItem: UIButton!
    @IBOutlet weak var itinOverviewLabel: UILabel!
    @IBOutlet weak var overviewStartDatePicker: UIDatePicker!
    @IBOutlet weak var overviewEndDatePicker: UIDatePicker!
    
    @IBOutlet weak var itineraryView: UIView!
    @IBOutlet weak var budgetView: UIView!
    @IBOutlet weak var packingListView: UIView!
    
    var itinOverviewText: String = "itinOverviewText"
    var itinEventsDict: Dictionary<String, Array<DayEvent>> = [:]
    var dateStorageList: Array<String> = ["start", "end"]
    
    
    @IBOutlet weak var packingListOverviewLabel: UILabel!
    @IBOutlet weak var packingListCheckCircle: UIButton!
    

    
    var packingItemsStorateList: Array<PackingItem> = []
    
    
    var budgetItemsStorageDict: Dictionary<String, Array<BudgetItem>> = [:]
    var budgetTotal: Double = 0.0
    @IBOutlet weak var budgetOverviewLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        itineraryView.layer.cornerRadius=20
        itineraryView.layer.borderWidth=4
        itineraryView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        
        budgetView.layer.cornerRadius=20
        budgetView.layer.borderWidth=4
        budgetView.layer.borderColor = CGColor(red: 173, green: 200, blue: 230, alpha: 1.0)
        
        packingListView.layer.cornerRadius=20
        packingListView.layer.borderWidth=4
        packingListView.layer.borderColor=CGColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        
        print("tripNo:", tripNo)
        super.viewDidLoad()
        packingListCheckCircle.isHidden = true
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        locationTextField.text = trip.destination //MARK: to be resolved just a bit later
        start = formatter.string(from: trip.startDate)
        end = formatter.string(from: trip.endDate)
        imageURL = trip.imageURL
        country = trip.country
        itinEventsDict = trip.itinerary
        budgetItemsStorageDict = trip.budget
        budgetTotal = trip.totalBudget
        packingItemsStorateList = trip.packingList
        overviewStartDatePicker.setDate(trip.startDate, animated: true)
        overviewEndDatePicker.setDate(trip.endDate, animated: true)
        PackingItem.saveToFile(packingItems: trip.packingList)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        trip = Trip(destination: locationTextField.text ?? "", country: country, startDate: overviewStartDatePicker.date, endDate: overviewEndDatePicker.date, itinerary: itinEventsDict, budget: budgetItemsStorageDict, totalBudget: self.budgetTotal, packingList: packingItemsStorateList, imageURL: imageURL)
        
        trips[tripNo] = trip
        Trip.saveToFile(trips: trips)
        
        //packing list
        
        var tempArray: Array<PackingItem> = []
        let titleArray = PackingItem.loadFromFile()
        packingItemsStorateList = titleArray ?? []
        for i in titleArray ?? []{
            if i.checked == false{
                tempArray.append(i)
            }
        }
        print(tempArray)
        
        
        if tempArray.count >= 1 {
            packingListCircleChecking(tempArray.randomElement() ?? tempArray[0])
        }
        if tempArray.isEmpty == false{
            packingListCircleChecking(tempArray[0])
        }else{
            if (titleArray ?? []).isEmpty == true{
                packingListOverviewLabel.text = "Packing List Preview!"
            }else{
                if packingItemsStorateList.isEmpty == false{
                    packingListCircleChecking(packingItemsStorateList.randomElement() ?? packingItemsStorateList[0])
                }
            }
        }
        packingItemsStorateList = titleArray ?? []
        PackingItem.saveToFile(packingItems: titleArray ?? [])
        
        //itinerary
        itinOverviewLabel.text = ""
        for (_,value) in self.itinEventsDict {
            for i in value {
                if i != DayEvent(destination: "", timeStart: "", timeEnd: "", date: "", notes: "") {
                    let tempText = "\(i.destination) (\(i.timeStart), \(i.date))"
                    if(itinOverviewLabel.text == "You have no upcoming events!" || itinOverviewLabel.text == "Upcoming event") {
                        itinOverviewLabel.text = tempText + "\n"
                    } else {
                        itinOverviewLabel.text?.append(tempText+"\n");
                    }
                } else {
                    itinOverviewLabel.text = "You have no upcoming events!"
                }
            }
        }
        
        //budget
        
        var spendingAddedUp: Double = 0.0
        for i in self.budgetItemsStorageDict.values{
            spendingAddedUp += Double(i.reduce(0,{x,y in x + y.cost}))
        }
        let string1 = "Spent $\(spendingAddedUp)"
        print("this is string1:", string1)
        
        var string2 = ""
        for (key,value) in self.budgetItemsStorageDict{
            let tempCategorizedSpending = Double(value.reduce(0, {x,y in x + y.cost}))
            var rounded = 0.0
            var percentage = 0.0
            if spendingAddedUp != 0{
            percentage = ((tempCategorizedSpending/spendingAddedUp) * 100)
            rounded = round(percentage)
            }
            let tempString = "\(rounded)% of spendings (\(key))\n"
            string2.append(tempString)
            print("this is string2:", rounded, percentage)
        }
        self.budgetOverviewLabel.text = "\(string1)"
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController{
            if let dest = navigationVC.topViewController as? ItinTableViewController{
                dest.delegate = self
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy"
                self.start = formatter.string(from: overviewStartDatePicker.date)
                self.end = formatter.string(from: overviewEndDatePicker.date)
                dateStorageList[0] = start
                dateStorageList[1] = end
                dest.schedule = dateStorageList
                dest.itinEventsDict = self.itinEventsDict
                
                dest.trips = trips
                dest.tripNo = tripNo
                
                for (_,value) in itinEventsDict{
                    for i in value{
                        if i.date != ""{
                            print("iiiii", i)
                            let interval = getDateInterval(startDate: start, date: i.date)
                            if ((dest.dayDictionary[interval]?.isEmpty) == nil){
                                dest.dayDictionary[interval] = [i]
                                print("vc.dayDictionary",dest.dayDictionary)
                            }else{
                                dest.dayDictionary[interval]?.append(i)
                                print("vc.dayDictionary else",dest.dayDictionary)
                            }
                        }
                    }
                }
            }
            
        }
        if let navigationVC = segue.destination as? UINavigationController{
            if let dest = navigationVC.topViewController as? ItinEventTableViewController{
                dest.creatingItemFromOverview = true
                
            }
        }
        if let navigationVC = segue.destination as? UINavigationController{
            if let dest = navigationVC.topViewController as? PackingListTableViewController{
                dest.delegate = self
                dest.packingItems = self.packingItemsStorateList
                dest.trips = self.trips
                dest.tripNo = self.tripNo
            }
        }
        
        if let navigationVC = segue.destination as? UINavigationController{
            if let dest = navigationVC.topViewController as? BudgetViewController{
                dest.budgetItemsDict = self.budgetItemsStorageDict
                dest.total = self.budgetTotal
                dest.delegate = self
                dest.trips = trips
                dest.tripNo = tripNo
            }
            
        
        
        if let dest = segue.destination as? TripViewController{
                self.trip = Trip(destination: self.locationTextField.text ?? "", country: self.country, startDate: self.overviewStartDatePicker.date, endDate: self.overviewEndDatePicker.date, itinerary: self.itinEventsDict, budget: self.budgetItemsStorageDict, totalBudget: self.budgetTotal, packingList: self.packingItemsStorateList, imageURL: self.imageURL)
                if trips.count < tripNo{
                    trips.append(trip)
                    dest.trips = trips
                } else {
                    trips[tripNo] = trip
                    dest.trips = trips
                }
                print("dest.trips", dest.trips)
                Trip.saveToFile(trips: trips)
            }
        }
    }
    
    
    
    @IBAction func backToItinEventsTableViewController (with segue: UIStoryboardSegue){
        if let source = segue.source as? ItinEventTableViewController{
            if segue.identifier == "unwindSave"{
                
                if var oldValue = itinEventsDict.updateValue([source.event], forKey: source.event.date) {
                    oldValue.append(source.event)
                    itinEventsDict[source.event.date] = oldValue
                } else {
                    itinEventsDict[source.event.date] = [source.event]
                }
                
                let upComing = findUpComing()
                if upComing != DayEvent(destination: "", timeStart: "", timeEnd: "", date: "", notes: ""){
                    let tempText = "\(upComing.destination) (\(upComing.timeStart), \(upComing.date))"
                    itinOverviewLabel.text = tempText
                } else {
                    itinOverviewLabel.text = "You have no upcoming events!"
                }
            }
            print("newitinEvents:", itinEventsDict)
            print("Jestem TU")
            DayEvent.saveToFile(dayEvents: itinEventsDict)
            
            trip = Trip(destination: locationTextField.text ?? "", country: country, startDate: overviewStartDatePicker.date, endDate: overviewEndDatePicker.date, itinerary: itinEventsDict, budget: budgetItemsStorageDict, totalBudget: self.budgetTotal, packingList: packingItemsStorateList, imageURL: imageURL)
            
            trips[tripNo] = trip
            Trip.saveToFile(trips: trips)
        }
    }
    
    @IBAction func backToOverViewController(with segue: UIStoryboardSegue){
        if let source = segue.source as? ItinTableViewController{
            
            for (key, value) in source.dayDictionary{
                if value.isEmpty == false{
                    //                    let isContained =  itinEventsDict.keys.contains(value[0].date)
                    self.itinEventsDict[value[0].date] = value
                }else{
                    
                    for i in source.dateArray{
                        print("Overview i, start:", i, self.start)
                        let intervalForDeleting = getDateInterval(startDate: self.start, date: end)
                        if intervalForDeleting == key{
                            self.itinEventsDict[i] = []
                            print("intervalForDeleting", intervalForDeleting)
                        }
                    }
                }
            }
        }
        print("list passed:", itinEventsDict)
        
        if let source = segue.source as? BudgetViewController{
            self.budgetItemsStorageDict = source.budgetItemsDict
            self.budgetTotal = source.total ?? 0
        }
        
    }
    
    func getDateInterval(startDate: String, date: String) -> Int{
        
        let formatter = DateFormatter()
        var interval = 0
        formatter.dateFormat = "MMM dd, yyyy"
        let dateStart = formatter.date(from: startDate)!
        let dateEndTemp = formatter.date(from: date)
        let dateEnd = dateEndTemp?.addingTimeInterval(TimeInterval(60 * 60 * 24))
        interval = Int( (dateEnd?.timeIntervalSince(dateStart))!/(24.0*60.0*60.0)) - 1
        return interval
    }
    
    func findUpComing() -> DayEvent{
        var interv: Double? = 0.0
        var upComingEvent = DayEvent(destination: "", timeStart: "", timeEnd: "", date: "", notes: "")
        
        for (_,value) in self.itinEventsDict{
            for i in value{
                let tempFormatter = DateFormatter()
                tempFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
                let tempStartTime = tempFormatter.date(from: "\(i.date), \(i.timeStart)")
                let tempInterval = tempStartTime?.timeIntervalSinceNow
                if tempStartTime ?? Date() >= Date(){
                    //
                    if interv == 0.0{
                        interv = tempInterval
                        upComingEvent = i
                    }else{
                        if tempInterval ?? 0.0 <= interv ?? 0.0 {
                            interv = tempInterval
                            upComingEvent = i
                        }
                    }
                }
            }
            
        }
        return upComingEvent
    }
    
    @IBAction func checkCircle1Tapped(_ sender: Any) {
        print("newest testing!", packingItemsStorateList)
        var count = -1
        for i in packingItemsStorateList{
            count += 1
            if packingListOverviewLabel.text == i.name{
                if i.checked{
                    packingItemsStorateList[count].checked = false
                    packingListCheckCircle.setImage(UIImage(named: "circle"), for: .normal)
                }else{
                    packingItemsStorateList[count].checked = true
                    packingListCheckCircle.setImage(UIImage(named: "checkmark.circle"), for: .normal)
                }
                
                
            }
        }
        PackingItem.saveToFile(packingItems: packingItemsStorateList)
    }
    
    
    

    
    class TextFieldWithReturn: UITextField, UITextFieldDelegate
    {
        
        required init?(coder aDecoder: NSCoder)
        {
            super.init(coder: aDecoder)
            self.delegate = self
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            textField.resignFirstResponder()
            return true
        }
        
    }
    
    
    
    
    @IBAction func locationEditingEnd(_ sender: Any) {
        locationTextField.resignFirstResponder()
        trips[tripNo].destination = locationTextField.text ?? ""
        Trip.saveToFile(trips: trips)
    }
    
    
    
    @IBAction func startDatePickerChanged(_ sender: Any) {
        trips[tripNo].startDate = overviewStartDatePicker.date
        Trip.saveToFile(trips: trips)
    }
    
    
    
    @IBAction func endDatePickerChanged(_ sender: Any) {
        
        trips[tripNo].endDate = overviewEndDatePicker.date
        Trip.saveToFile(trips: trips)
    }
}
