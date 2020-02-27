class Lister {
    
    static let shared = Lister()
    
    var lists: [List]  {
        get {
            return Safe.shared.getLists()
        }
        set {
            Safe.shared.setLists(newValue)
        }
    }
    
    func createList(name: String) {
        lists.append(List(id: UUID().uuidString, name: name))
    }
    
    func deleteList(id: String) {
        lists = lists.filter({ $0.id != id })
    }
    
    func addList(_ list: List) {
        lists.append(list)
    }
    
    func getList(id: String) -> List {
        return lists.filter({ $0.id == id }).first!
    }
    
    func update(list: List) {
        deleteList(id: list.id)
        addList(list)
    }
}
