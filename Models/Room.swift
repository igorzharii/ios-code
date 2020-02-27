struct Room {
    var name: String = ""
    var id: String = ""
    var users: [User] = [User]()
    var usersCount: Int = 0
    
    var joined: Bool {
        return users.contains(where: {$0.id == Safe.shared.get(.firebaseUID)})
    }
    var favorited: Bool {
        get {
             return Safe.shared.getFavedRooms().contains(self.id)
        }
        set {
            if Safe.shared.getFavedRooms().contains(self.id) {
                Safe.shared.setFavedRooms(Safe.shared.getFavedRooms().filter({ $0 != self.id }))
            } else {
                var roomIds = Safe.shared.getFavedRooms()
                roomIds.append(self.id)
                Safe.shared.setFavedRooms(roomIds)
            }
        }
    }
    
    init(name: String, genre: String, creator: String, password: String, expiryTS: Int?) {
        self.name = name
        self.genre = genre
        self.creator = creator.count > 0 ? creator : "name"
        self.password = password
        if expiryTS == nil || expiryTS == 0 {
            self.expiryTS = Int(Date().timeIntervalSince1970) + 604800
        }
    }
}


