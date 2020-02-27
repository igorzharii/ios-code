enum SearchType: String {
    case allSongs
    case topSongs
    case autocomplete
    case searchResults
    case recommendations
    case noResult
}

class SearchViewModel {
    
    var searchType: SearchType = .topSongs
    
    var topSongs: [RadioSong] = [RadioSong]()
    
    var allSongs: [RadioSong] = [RadioSong]()
    
    var autocompletes: [RadioSong] = [RadioSong]() {
        didSet {
            autocompleteTypes = Array(Set(self.autocompletes.map({ $0.autocompleteType })))
        }
    }
    
    var autocompleteTypes: [AutocompleteType] = [AutocompleteType]()
    
    var recommendations: [RadioSong] = [RadioSong]()
    
    var loading: Bool = false
    
    var list: List!
    
    func autocompleteCells(type: AutocompleteType) -> [SearchCellData] {
        return autocompletes.filter({ $0.autocompleteType == type}).map({ SearchCellData(type: .autocompleteCell, song: $0) })
    }
    
    var cells: [SearchCellData] {
        get {
            var cells: [SearchCellData] = [SearchCellData]()
            
            guard !loading else {
                cells.append(SearchCellData(type: .loadingCell))
                return cells
            }
            
            switch searchType {
            case .topSongs:
                topSongs.forEach({ cells.append(SearchCellData(type: .songCell, song: $0)) })
            case .noResult:
                cells.append(SearchCellData(type: .headerCell, text: "No search results "))
            case .allSongs:
                cells.append(SearchCellData(type: .headerCell, text: "A: \(allSongs[0].artist)"))
                allSongs.forEach({ cells.append(SearchCellData(type: .autocompleteCell, song: $0)) })
            case .autocomplete:
                if autocompleteTypes.count == 1 {
                    cells.append(contentsOf: autocompleteCells(type: autocompleteTypes[0]))
                } else {
                    cells.append(SearchCellData(type: .headerCell, text: "S:"))
                    cells.append(contentsOf: autocompleteCells(type: .title))
                    cells.append(SearchCellData(type: .headerCell, text: "A:"))
                    cells.append(contentsOf: autocompleteCells(type: .artist))
                }
            case .searchResults:
                break
            case .recommendations:
                cells.append(SearchCellData(type: .headerCell, text: "R:"))
                recommendations.forEach({ cells.append(SearchCellData(type: .autocompleteCell, song: $0)) })
            }
            return cells
        }
    }
    
    func startSearch(_ type: SearchType) {
        guard !loading else { return }
        searchType = type
        topSongs.removeAll()
        allSongs.removeAll()
        autocompletes.removeAll()
        recommendations.removeAll()
        loading = true
    }
}
