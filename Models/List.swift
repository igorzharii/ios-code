enum ListType: String, Codable {
    case own
    case room
}

class List: Codable {
    var id: String = ""
    var index: Int = 0
    var name: String = ""
    var type: ListType = .own
    var songs: [RadioSong] = [RadioSong]() {
        didSet {
            Lister.shared.update(list: self)
        }
    }
    
    init(id: String, name: String, type: ListType = .own) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    func add(_ song: RadioSong) {
        if !contains(song) { songs.append(song) }
    }
    
    func remove(_ song: RadioSong) {
        if contains(song) { songs = songs.filter({ $0.title != song.title }) }
    }
    
    func contains(_ song: RadioSong) -> Bool {
        return songs.contains(where: { $0.title == song.title })
    }
}
