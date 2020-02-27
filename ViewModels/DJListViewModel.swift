class ListViewModel {
    
    var list: List!
    
    var cells: [ListCellData] {
        get {
            var cells: [ListCellData] = [ListCellData]()
            
            cells.append(ListCellData(type: .addSongsCell))
            list.songs.forEach({ cells.append(ListCellData(type: .songCell, song: $0)) })
            return cells
        }
    }
    
}
