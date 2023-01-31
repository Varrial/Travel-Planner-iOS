import UIKit

class ItinEventsTableViewController: UITableViewController {
    var dayNo: Int = 0
    var events: Array<DayEvent> = [DayEvent(destination: "add in the day's events!", timeStart: "swipe left to delete an event", timeEnd: "enjoy!!", date: "", notes:"")]
    var eventNo: Int = 0
    var anotherEventNoForPassingDate: Int = 0
    var delegate: ItinDataDelegate?
    var dateArray: Array<Any> = []
    var itinEventsDict: Dictionary<String,Array<DayEvent>> = [:]
    var trips: [Trip] = []
    var tripNo: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillLayoutSubviews() {
        events.sort{$0.timeStart < $1.timeStart}
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itinEventCell", for: indexPath)
        cell.textLabel?.text = events[indexPath.row].destination
        let text = "\(events[indexPath.row].timeStart) - \(events[indexPath.row].timeEnd)"
        cell.detailTextLabel?.text = text

        

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let eventTemp = events.remove(at: fromIndexPath.row)
        events.insert(eventTemp, at: to.row)
        tableView.reloadData()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventsToEventDetail"{
            eventNo = tableView.indexPathForSelectedRow!.row
            if let navigationVC = segue.destination as? UINavigationController{
                if let dest = navigationVC.topViewController as? ItinEventTableViewController{
                dest.eventNo = eventNo
                dest.event = events[eventNo]
                dest.dateArray = self.dateArray
                }
            }
        }
        
        if segue.identifier == "eventsToNewEvent"{
            if let navigationVC = segue.destination as? UINavigationController{
                if let dest = navigationVC.topViewController as? ItinEventTableViewController {
                    dest.isAnExistingEvent = false
                    dest.dateArray = self.dateArray
                    dest.eventNo = anotherEventNoForPassingDate
                }
            }
        }
        
        if segue.identifier == "backToItineraryTableViewController"{
            if let dest = segue.destination as? ItinTableViewController{
                dest.dayDictionary[dayNo] = events
            }
        }
    }
    
    
    @IBAction func backToItinEventsTableViewController (with segue: UIStoryboardSegue){
        if let source = segue.source as? ItinEventTableViewController{
            if source.isAnExistingEvent == true{
                events[eventNo] = source.event
                tableView.reloadData()
            }else{
                if source.event != nil {
                    events.append(source.event)
                    tableView.reloadData()
                }
            }
        }
        
        print("view did appear datearray:", dateArray)
        if dateArray.count >= dayNo{
        let str = dateArray[dayNo]
        print(events)
        itinEventsDict[str as? String ?? ""] = events
            print(itinEventsDict)
        trips[tripNo].itinerary = itinEventsDict
            Trip.saveToFile(trips: trips)
        }
    }
}
