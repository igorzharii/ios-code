import UIKit
import Kingfisher

protocol SongCellDelegate {
    func addSongToList(_ song: RadioSong)
    func deleteSongFromList(_ song: RadioSong)
}

class SongCell: BaseCell {
    
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addSongButton: UIButton!
    
    var delegate: SongCellDelegate?
    var song: RadioSong!
    var list: List!
    
    @IBAction func addSongButtonTapped(_ sender: Any) {
        list.add(song)
        updateUI()
        delegate?.addSongToList(song)
    }
    
    @IBAction func deleteSongButtonTapped(_ sender: Any) {
        list.remove(song)
        updateUI()
        delegate?.deleteSongFromList(song)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        addSongButton.addSmallCorners()
        deleteSongButton.addSmallCorners()
        deleteSongButton.backgroundColor = Theme.Color.red
        deleteSongButton.imageView?.tintColor = Theme.Color.white
        artworkImage.layer.cornerRadius = 5
        artworkImage.layer.masksToBounds = true
        artworkImage.layer.borderColor = Theme.Color.black.cgColor
        artworkImage.layer.borderWidth = 1
        artworkImage.image = UIImage(named: "song-placeholder")
        addedLabel.text = LocalizableStrings.added.localized
    }
    
    func resetUI() {
        addSongButton.isHidden = true
        deleteSongButton.isHidden = true
        addedLabel.isHidden = true
        artworkImage.image = UIImage(named: "song-placeholder")
    }
    
    func updateUI() {
        addSongButton.isHidden = list.contains(song)
        deleteSongButton.isHidden = !list.contains(song)
        addedLabel.isHidden = !list.contains(song)
    }
    
    func fillUI() {
        titleLabel.text = song.title
        
        ImageCacher().getCacheOrFetch(for: song, set: artworkImage)
    }
    
    override func configure(song: RadioSong, delegate: SongCellDelegate, list: List) {
        super.configure(song: song, delegate: delegate, list: list)
        self.delegate = delegate
        self.song = song
        self.list = list
        
        resetUI()
        updateUI()
        fillUI()
    }
    
}
