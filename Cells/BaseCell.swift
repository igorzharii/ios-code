class BaseCell: UITableViewCell {
    
    func configure() { selectionStyle = .none }
    
    func configure(history: History) { }
    
    func configure(song: RadioSong, delegate: SongCellDelegate, list: List) { configure() }
}
