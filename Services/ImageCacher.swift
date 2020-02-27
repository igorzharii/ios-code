import Kingfisher
import UIKit

struct ImageCacher {

    let artworkURL = "http://domain.com/artwork.png"
    let kfLoadingOptions: KingfisherOptionsInfo = [.forceTransition, .transition(.fade(0.5))]
    
    func isCached(cacheKey: String) -> Bool {
        return ImageCache.default.imageCachedType(forKey: cacheKey) != .none
    }
    
    func getCacheOrFetch(for song: RadioSong, set imageView: UIImageView) {
        if song.artUrl != "" && isCached(cacheKey: song.artUrl) {
            setFromCache(cacheKey: song.artUrl, set: imageView)
        } else {
            fetchImage(for: song, set: imageView)
        }
    }
    
    func fetchImage(for song: RadioSong, set imageView: UIImageView) {
        Fetcher().artwork(artist: song.artist, title: song.title, completion: { error, artUrl in
            guard artUrl != self.onradioArtwork && artUrl != "" else { return }
            song.artUrl = artUrl
            imageView.kf.setImage(with: URL(string: artUrl), placeholder: UIImage(named: "song-placeholder"), options: self.kfLoadingOptions, completionHandler: nil)
        })
    }
    
    func setFromCache(cacheKey: String, set imageView: UIImageView) {
        ImageCache.default.retrieveImage(forKey: cacheKey, options: nil) {
            image, cacheType in
            if let image = image {
                imageView.image = image
            } else {
                print("Doesn't exist in cache.")
            }
        }
    }
}
