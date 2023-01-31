import UIKit

class ItinEventTableViewController: UITableViewController, UITextViewDelegate {
    
    var event: DayEvent!
    var isAnExistingEvent = true
    var eventNo: Int = 0
    let datePicker = UIDatePicker()
    var dateToSet: String = ""
    let formatter = DateFormatter()
    let formatter2 = DateFormatter()
    var dateArray: Array<Any> = []
    var creatingItemFromOverview: Bool = false
    var delegate: ItinDataDelegate?

    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var eventNoteView: UITextView!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNoteView.text = ""
        formatter.dateFormat = "MMM dd, yyyy"
        formatter2.dateFormat = "HH:mm"
        
        eventNoteView.layer.cornerRadius = 10

        
        if event != nil {
            isAnExistingEvent = true
            destinationTextField.text = event.destination
            startTimePicker.setDate(convertStringToTime(string: event.timeStart), animated: true)
            endTimePicker.setDate(convertStringToTime(string: event.timeEnd), animated: true)
            
            eventNoteView.text = event.notes
            guard let datedate = formatter.date(from: event.date) else { return }
            dateDatePicker.setDate(datedate, animated: true)
        } else {
            print("event is not here!")
            isAnExistingEvent = false
            if creatingItemFromOverview == false{
            guard let defaultDate = formatter.date(from: dateArray[eventNo] as? String ?? "") else { return }
            print("dateArray:", dateArray, eventNo)
            dateDatePicker.setDate(defaultDate, animated: true)
            }
        }
        
        eventNoteView.delegate = self
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "unwindSave"{
            switch isAnExistingEvent {
            case true:
                if segue.destination is ItinEventsTableViewController{
                    event.destination = destinationTextField.text ?? ""
                    let startTP = formatter2.string(from: startTimePicker.date)
                    event.timeStart = startTP
                    let endTP = formatter2.string(from: endTimePicker.date)
                    event.timeEnd = endTP
                    event.notes = eventNoteView.text ?? "Notes"
                    event.date = formatter.string(from: dateDatePicker.date)
                    print("event:",event as Any)
                        }
            default:
                let startTP = formatter2.string(from: startTimePicker.date)
                let endTP = formatter2.string(from: endTimePicker.date)
                event = DayEvent(destination:destinationTextField.text ?? "", timeStart: startTP, timeEnd: endTP, date: formatter.string(from: dateDatePicker.date), notes: eventNoteView.text ?? "Notes")
            }
        }
    }
    
    
    @IBAction func destinationEditingEnd(_ sender: Any) {
        destinationTextField.resignFirstResponder()
    }

    
    @IBAction func startTimeEditingEnd(_ sender: Any) {
        startTimeTextField.resignFirstResponder()
    }
    
    
    @IBAction func endTimeEditingEnd(_ sender: Any) {
        endTimeTextField.resignFirstResponder()
    }
    
    
    func convertStringToTime(string: String) -> Date{
        print("dtst:", string)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH:mm"
        return formatter2.date(from: string) ?? Date()
    }
}


