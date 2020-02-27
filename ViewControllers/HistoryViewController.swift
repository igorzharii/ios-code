import UIKit

class HistoryViewController: BaseViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var historyDataProvider = HistoryDataProvider()
    var room: Room = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        title = "History"
        
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Fetcher().roomHistory(roomId: room.id, completion: { (error, history) in
            self.historyDataProvider.viewModel.history = history
            self.historyTableView.reloadData()
        })
    }
    
    func setupTable() {
        
        historyDataProvider.controller = self
        historyTableView.dataSource = historyDataProvider
        historyTableView.delegate = historyDataProvider
        historyTableView.tableFooterView = UIView()
        historyTableView.backgroundColor = UIColor.clear
        historyTableView.estimatedRowHeight = 2.0
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.register(UINib(nibName: HistoryCellType.loadingCell.value, bundle: nil), forCellReuseIdentifier: HistoryCellType.loadingCell.value)
        historyTableView.register(UINib(nibName: HistoryCellType.historyCell.value, bundle: nil), forCellReuseIdentifier: HistoryCellType.historyCell.value)
    }
}
