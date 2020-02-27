import UIKit
import Eureka

class ProfileViewController: FormViewController {
    
    var updatingUsername: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationOptions = .Disabled
        tableView.rowHeight = 44
        
        setupCloseButton()
        setupVersionLabel()
        
        title = "Profile"
        
        form +++ Section("Account information")
            <<< TextRow(){ row in
                row.title = "Username"
                row.placeholder = "Your username"
                row.tag = CreateRoomRowTag.roomName.rawValue
                row.value = Safe.shared.get(.userUsername)
                
                }.cellSetup{ cell, row in
                    cell.textField.returnKeyType = .done
                }.cellUpdate{ cell, row in
                    cell.backgroundColor = Theme.Color.yellow5
                    cell.titleLabel?.textColor = Theme.Color.grey70
                    cell.textField.textColor = Theme.Color.grey90
                }.onCellHighlightChanged{ cell, row in
                    cell.titleLabel?.textColor = Theme.Color.grey90
            }
        
        form +++ Section()
            <<< CustomButtonRow() { row in
                
                }.cellSetup{cell, row in
                    cell.button.setTitle("Logout", for: .normal)
                    let logoutImage = UIImage(named: "logout-sm")?.withColor(Theme.Color.grey90)
                    cell.button.setImage(logoutImage, for: .normal)
                    cell.delegate = self
        }
    }
    
    func setupCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "close-sm"), style: .plain, target: self, action: #selector(close))
        closeButton.tintColor = Theme.Color.yellow80
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func setupVersionLabel() {
        let versionLabel = UILabel(frame: CGRect(x: Constants.bounds.width - 150, y: Constants.bounds.height - 30, width: 140, height: 20))
        versionLabel.textColor = Theme.Color.grey90
        versionLabel.textAlignment = .right
        versionLabel.text = "V: \(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
        view.addSubview(versionLabel)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func closeWith(_ completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    override func textInputShouldReturn<T>(_ textInput: UITextInput, cell: Cell<T>) -> Bool where T : Equatable {
        updateUsername(textInput)
        return true
    }
    
    override func textInputShouldEndEditing<T>(_ textInput: UITextInput, cell: Cell<T>) -> Bool where T : Equatable {
        updateUsername(textInput)
        return true
    }
    
    override func textInput<T>(_ textInput: UITextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String, cell: Cell<T>) -> Bool where T : Equatable {
        textInput.replace(textInput.fullRange, withText: textInput.text.lowercased().removeWhiteSpace())
        return true
    }
    
    func updateUsername(_ textInput: UITextInput) {
        guard !updatingUsername else { return }
        guard textInput.text != "" && textInput.text != Safe.shared.get(.userUsername) else {
            textInput.replace(textInput.fullRange, withText: Safe.shared.get(.userUsername))
            finishEditing()
            return
        }
        updatingUsername = true
        Loginner.shared.updateUsername(textInput.text)
        finishEditing()
        updatingUsername = false
    }
    
}

extension ProfileViewController: CustomButtonCellDelegate {
    func buttonTapped() {
        Loginner.shared.logout()
        closeWith({
            Alerter.shared.showAlert(.topMessage, true, LocalizableStrings.loggedOutSuccessfully.localized, nil)
        })
    }
}
