import UIKit

class EditPackingItemTableViewController: UITableViewController, UITextViewDelegate {

    var packingItem: PackingItem!
    var newPackingItem = false
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if packingItem != nil {
            nameTextField.text = packingItem.name
            notesTextView.text = packingItem?.note
        } else {
            packingItem = PackingItem(name: "", checked: false, note: notesTextView.text ?? "")
            notesTextView.delegate = self
        }
        //trying to make textview dismissible
        notesTextView.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromDetail"{
        if self.newPackingItem == true{
            self.packingItem = PackingItem(name: nameTextField.text ?? "", checked: false, note: notesTextView.text ?? "")
            print("created item here", self.packingItem)
            } else {
                self.packingItem?.name = nameTextField.text ?? ""
                self.packingItem?.note = notesTextView.text ?? ""
            
        }
    }
}
    
    
    @IBAction func textFieldUpdated(_ sender: UITextField) {
        packingItem.name =  sender.text ?? ""
    }
    
    @IBOutlet weak var notesTextFieldUpdated: UITextView!
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func packingItemEditingEnded(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
}
 
