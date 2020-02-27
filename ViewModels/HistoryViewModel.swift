class HistoryViewModel {
    var history: [History] = [History]()
    
    var cells: [HistoryCellData] {
        get {
            var cells: [HistoryCellData] = [HistoryCellData]()
            
            guard history.count > 0 else {
                cells.append(HistoryCellData(type: .loadingCell, history: nil))
                return cells
            }
            history.forEach({ cells.append(HistoryCellData(type: .historyCell, history: $0)) })
            return cells
        }
    }
}
