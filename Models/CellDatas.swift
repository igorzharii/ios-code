struct HistoryCellData {
    var type: HistoryCellType
    var history: History?
}

struct ListCellData {
    var type: ListCellType
    var song: RadioSong?
    var delegate: SongCellDelegate?
    
    init(type: ListCellType, song: RadioSong? = nil, delegate: SongCellDelegate? = nil) {
        self.type = type
        self.song = song
        self.delegate = delegate
    }
}
