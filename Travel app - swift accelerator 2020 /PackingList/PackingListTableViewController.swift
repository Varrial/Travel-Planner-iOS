import UIKit

class PackingListTableViewController: UITableViewController {
    var delegate: PackingListDataDelegate?
    var isChecked: Bool = false
    
    var trips: [Trip] = []
    var tripNo: Int = 0

   
    
    var packingItems = [
        PackingItem(name: "Add in the things you wish to pack!", checked: false, note: "")
    ]
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedPackingItems = PackingItem.loadFromFile(){
            packingItems = loadedPackingItems
            print("File founded. Loading packingItems.")
        }else{
            print("No packingItems! Make some.")
            packingItems = []
        }
        
        packingItems = packingItems.sorted{
            (!$0.checked && $1.checked)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PackingItem.saveToFile(packingItems: packingItems)
        trips[tripNo].packingList = packingItems
        Trip.saveToFile(trips: trips)
        print(trips)
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.printPackingListItem(titleArray: packingItems, isChecked: isChecked)
        print("what is checked", isChecked)
        PackingItem.saveToFile(packingItems: packingItems)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "packingListItem", for: indexPath) as! PackingListTableViewCell
        cell.PackingListvc = self
        cell.textLabel?.text = packingItems[indexPath.row].name
        if packingItems[indexPath.row].checked {
            cell.circleButton.setImage(UIImage(named: "checkmark.circle"), for: .normal)
        } else {
            cell.circleButton.setImage(UIImage(named: "circle"), for: .normal)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            packingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let packingitem = packingItems.remove(at: fromIndexPath.row)
        packingItems.insert(packingitem, at: to.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.viewControllers.first as! EditPackingItemTableViewController
            
            if tableView.indexPathForSelectedRow != nil {
            dest.packingItem = packingItems[tableView.indexPathForSelectedRow!.row]
            } else {
                dest.newPackingItem = true
            }
    }
}
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showDetail", sender: self)
        
        let alert = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: {UITextField in UITextField.placeholder = "New item to pack:"})
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {action in
            
            if let PackingListAlertItem = alert.textFields?.first?.text {
                print("new item: \(PackingListAlertItem)")
            }
        }))
        
        self.present(alert, animated: true)
    }
     
    @IBAction func unwindToPackingItems(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromDetail" {
            let source = segue.source as! EditPackingItemTableViewController
            if source.newPackingItem {
                packingItems.append(source.packingItem)
                PackingItem.saveToFile(packingItems: packingItems)
            }else{
                packingItems[tableView.indexPathForSelectedRow!.row] = source.packingItem
                PackingItem.saveToFile(packingItems: packingItems)
            }
        }
    }
}
