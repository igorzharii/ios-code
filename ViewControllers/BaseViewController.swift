import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.Color.grey5
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
}

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    func setupNavBar() {
        
        navigationBar.tintColor = Theme.Color.yellow80
        navigationBar.barTintColor = Theme.Color.grey90
        let attributes = [NSAttributedString.Key.foregroundColor: Theme.Color.yellow80]
        navigationBar.titleTextAttributes = attributes
        navigationBar.isTranslucent = false
        navigationItem.titleView?.tintColor = Theme.Color.yellow80
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = attributes
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.Color.yellow80]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.Color.yellow80]
            navBarAppearance.backgroundColor = Theme.Color.grey90
            navigationBar.isTranslucent = false
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
}
