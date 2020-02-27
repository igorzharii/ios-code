import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDataProvider = SearchDataProvider()
    var setListdelegate: SetListDataProviderDelegate?
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        setListdelegate?.willReturn()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        title = "Add"
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchDataProvider.searchTopSongs()
    }
    
    func setup() {
        
        doneButton.tintColor = Theme.Color.black
        doneButton.titleLabel?.font = Theme.Font.size15Bold
        
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        
        searchDataProvider.controller = self
        searchDataProvider.tableView = searchTableView
        searchTableView.dataSource = searchDataProvider
        searchTableView.delegate = searchDataProvider
        searchTableView.tableFooterView = UIView()
        searchTableView.backgroundColor = UIColor.clear
        searchTableView.estimatedRowHeight = 2.0
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.register(UINib(nibName: SearchCellType.loadingCell.value, bundle: nil), forCellReuseIdentifier: SearchCellType.loadingCell.value)
        searchTableView.register(UINib(nibName: SearchCellType.songCell.value, bundle: nil), forCellReuseIdentifier: SearchCellType.songCell.value)
        searchTableView.register(UINib(nibName: SearchCellType.autocompleteCell.value, bundle: nil), forCellReuseIdentifier: SearchCellType.autocompleteCell.value)
        searchTableView.register(UINib(nibName: SearchCellType.headerCell.value, bundle: nil), forCellReuseIdentifier: SearchCellType.headerCell.value)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { finishEditing(); return true }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { return true }
    
    @objc func finishEditing() { view.endEditing(true) }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        searchDataProvider.searchAutocomplete(text: searchTextField.text!)
    }
}
