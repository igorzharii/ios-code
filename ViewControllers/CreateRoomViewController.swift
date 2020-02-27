import UIKit
import Eureka

enum CreateRoomRowTag: String, CaseIterable {
    case roomName
    case type
    case creatorName
    case expiryDate
    case password
}

class CreateRoomViewController: FormViewController {
    
    var creatingRoom: Bool = false
    var types: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New"
        
        form +++ Section("info")
        <<< TextRow(){ row in
            row.title = "name"
            row.placeholder = "name"
            row.tag = CreateRoomRowTag.roomName.rawValue
            }.cellUpdate{ cell, row in
                cell.backgroundColor = Theme.Color.yellow5
                cell.titleLabel?.textColor = Theme.Color.grey70
                cell.textField.textColor = Theme.Color.grey90
            }.onCellHighlightChanged{ cell, row in
                cell.titleLabel?.textColor = Theme.Color.grey90
            }
        <<< PickerInlineRow<String>() { row in
            row.title = "type"
            row.value = types[0]
            row.options = types
            row.tag = CreateRoomRowTag.type.rawValue
            }.cellUpdate{ cell, row in
                cell.backgroundColor = Theme.Color.yellow5
                cell.detailTextLabel?.textColor = Theme.Color.grey60
                cell.textLabel?.textColor = Theme.Color.grey70
            }.onCellHighlightChanged{ cell, row in
                cell.detailTextLabel?.textColor = Theme.Color.grey90
                cell.textLabel?.textColor = Theme.Color.grey90
            }.onCellSelection({ cell, row in
                cell.detailTextLabel?.textColor = Theme.Color.grey90
                cell.textLabel?.textColor = Theme.Color.grey90
            })
        form +++ Section()
        <<< CustomButtonRow() { row in

            }.cellSetup{cell, row in
                cell.delegate = self
            }
    }
}

extension CreateRoomViewController: CustomButtonCellDelegate {
    func buttonTapped() {
        guard !creatingRoom else { return }
        creatingRoom = true
        let values = form.values()
        let date = values[CreateRoomRowTag.expiryDate.rawValue] as! Date
        let timeStamp = date.timeIntervalSince1970
        let type = values[CreateRoomRowTag.type.rawValue] as? String ?? ""
    
        let newRoom = Room(name: values[CreateRoomRowTag.roomName.rawValue] as? String ?? "",
                           type: type.lowercased(),
                           creator: values[CreateRoomRowTag.creatorName.rawValue] as? String ?? "",
                           password: values[CreateRoomRowTag.password.rawValue] as? String ?? "",
                           expiryTS: Int(timeStamp))
        Fetcher().createRoom(room: newRoom, completion: { error, success in
        
            print ("creation success: \(success)")
            self.creatingRoom = false
            self.showResult(success)
        })
    }

    func showResult(_ success: Bool) {
        Alerter.shared.showAlert(.topMessage, success, success ? LocalizableStrings.createdSuccessfully.localized : LocalizableStrings.couldntCreate.localized, success ? { self.navigationController?.popViewController(animated: true) } : nil)
    }
}

class FormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        form.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .next, defaultKeyboardType: .go)
        view.backgroundColor = Theme.Color.grey5
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func finishEditing() {
        view.endEditing(true)
    }
    
    override var customNavigationAccessoryView: (UIView & NavigationAccessory)? {
        get {
            let navView = NavigationAccessoryView()
            navView.backgroundColor = Theme.Color.grey5
            navView.previousButton.tintColor = Theme.Color.grey90
            navView.nextButton.tintColor = Theme.Color.grey90
            navView.doneButton.tintColor = Theme.Color.grey90
            return navView
        }
    }
}
