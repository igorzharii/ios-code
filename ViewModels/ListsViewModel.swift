class ListsViewModel {
    
    var lists: [List] {
        get {
            return Lister.shared.lists
        }
    }
    
    var cells: [ListsCellData] {
        get {
            
            var cells: [ListsCellData] = [ListsCellData]()
            
            cells.append(ListsCellData(type: .addListCell))
            for (index, list) in lists.enumerated() {
                let l = list
                l.index = index
                cells.append(ListsCellData(type: .listCell, list: l))
            }
            return cells
        }
    }
    
}
