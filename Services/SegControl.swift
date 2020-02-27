import UIKit

protocol SegControlDelegate {
    func segmentIndexChanged(newIndex: Int)
}

class SegControl: UISegmentedControl {
    var controller: UIViewController?
    var delegate: SegControlDelegate?
    var previouslySelectedSegment: Int = 0
    var popularImage: UIImage = UIImage()
    var favoritesImage: UIImage = UIImage()
    var createRoomImage: UIImage = UIImage()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addTarget(self, action: #selector(segmentIndexChanged), for: .valueChanged)
        setupUI()
    }
    
    
    func setupUI() {
        
        tintColor = Theme.Color.grey90
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = Theme.Color.grey90
        }
        layer.borderColor = Theme.Color.grey90.cgColor
        popularImage = UIImage.textEmbededImage(image: UIImage(named: "popular-sm")!, string: "Popular", color: Theme.Color.yellow80).withColor(Theme.Color.yellow80).withRenderingMode(.alwaysOriginal)
        favoritesImage = UIImage.textEmbededImage(image: UIImage(named: "favorites-sm")!, string: "Favorites", color: Theme.Color.yellow80).withColor(Theme.Color.yellow60).withRenderingMode(.alwaysOriginal)
        createRoomImage = UIImage.textEmbededImage(image: UIImage(named: "create-room-sm")!, string: "Create", color: Theme.Color.yellow80).withColor(Theme.Color.yellow60).withRenderingMode(.alwaysOriginal)
        setImage(popularImage, forSegmentAt: 0)
        setImage(favoritesImage, forSegmentAt: 1)
        setImage(createRoomImage, forSegmentAt: 2)
    }
    
    
    @objc func segmentIndexChanged() {
        delegate?.segmentIndexChanged(newIndex: selectedSegmentIndex)
        switch selectedSegmentIndex {
        case 0:
            setImage(popularImage.withColor(Theme.Color.yellow80).withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
            setImage(favoritesImage.withColor(Theme.Color.yellow60).withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
        case 1:
            setImage(popularImage.withColor(Theme.Color.yellow60).withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
            setImage(favoritesImage.withColor(Theme.Color.yellow80).withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
        case 2:
            selectedSegmentIndex = previouslySelectedSegment
        default:
            break
        }
        previouslySelectedSegment = selectedSegmentIndex
    }
}
