import UIKit
import SwiftMessages

extension UIViewController {
    
    func add(_ child: UIViewController) -> UIViewController {
        addChild(child)
        child.view.alpha = 0.0
        view.addSubview(child.view)
        child.didMove(toParent: self)
        UIView.animate(withDuration: 0.3, animations: {
            child.view.alpha = 1.0
        })
        return child
    }
    
    func addNoAnim(_ child: UIViewController) -> UIViewController {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        return child
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }, completion: { _ in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
    
    @objc func showCreateRoomScreen() {
        if Safe.shared.loggedIn {
            pushCreateRoomVC()
        } else {
            presentAuthVC()
        }
    }
    
    @objc func showProfileScreen() {
        if Safe.shared.loggedIn {
            presentProfileNVC()
        } else {
            presentAuthVC()
        }
    }
    
    func presentProfileNVC() {
        let profileNVC = Constants().initiateVCFromMainStoryboard(name: Constants.profileNVC) as! UINavigationController
        navigationController?.present(profileNVC, animated: true, completion: nil)
    }
    
    func presentAuthVC() {
        Alerter.shared.showAuthDialog(controller: self, { })
    }
    
    
    func pushListsVC() {
        let listsVC = Constants().initiateVCFromMainStoryboard(name: Constants.listsViewController) as! ListsViewController
        navigationController?.pushViewController(listsVC, animated: true)
    }
    
    func pushWebVC(callsign: String, url: String) {
        let webVC = Constants().initiateVCFromMainStoryboard(name: Constants.webViewController) as! WebViewController
        webVC.title = callsign
        webVC.webLink = url
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func pushHistoryVC(room: Room) {
        let historyVC = Constants().initiateVCFromMainStoryboard(name: Constants.historyViewController) as! HistoryViewController
        historyVC.room = room
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
