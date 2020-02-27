enum HistoryCellType: String {
    case loadingCell
    case historyCell
    
    var value : String {
        return self.rawValue.capitalizingFirstLetter()
    }
}
