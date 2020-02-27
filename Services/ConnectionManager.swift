import Alamofire
import UIKit

protocol ConnectionManagerDelegate {
    func gotInternet()
}

class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    var noConnectionView: UIView!
    var delegate: ConnectionManagerDelegate?
    
    override init() {
        super.init()
        
        startNetworkReachabilityObserver()
    }
    
    func noConnectionMessage(show: Bool) {
        let rootVC = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
        if show {
            if self.noConnectionView == nil {
                initNoConnectionView()
                rootVC.view.addSubview(noConnectionView)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.noConnectionView.frame.origin.y = Constants.bounds.size.height - self.noConnectionView.frame.size.height
            })
        } else {
            delegate?.gotInternet()
            if self.noConnectionView != nil {
                UIView.animate(withDuration: 0.3, animations: {
                    self.noConnectionView.frame.origin.y = Constants.bounds.size.height
                }, completion: { success in
                    self.noConnectionView.removeFromSuperview()
                    self.noConnectionView = nil
                })
            }
        }
    }
    
    func initNoConnectionView() {
        let additionalHeight = Constants.bounds.size.height == 812 || Constants.bounds.size.height == 896 ? CGFloat(20) : CGFloat(0)
        let view = UIView(frame: CGRect(x: 0, y: Constants.bounds.size.height, width: Constants.bounds.size.width, height: 30 + additionalHeight))
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.size.width, height: view.size.height - additionalHeight))
        label.font = Theme.Font.size15Bold
        label.textAlignment = .center
        
        label.text = LocalizableStrings.pleaseCheckYourConnection.localized
        
        view.backgroundColor = Theme.Color.red
        label.textColor = Theme.Color.yellow80
        
        
        view.addSubview(label)
        
        noConnectionView = view
    }
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "apple.com")
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            self.reactToCurrentStatus(status)
        }
        reachabilityManager?.startListening()
    }
    
    func reactToCurrentStatus(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
            
        case .notReachable:
            self.noConnectionMessage(show: true)
            print("The network is not reachable")
            
        case .unknown :
            print("It is unknown whether the network is reachable")
            
        case .reachable(.ethernetOrWiFi):
            self.noConnectionMessage(show: false)
            print("The network is reachable over the WiFi connection")
            
        case .reachable(.wwan):
            self.noConnectionMessage(show: false)
            print("The network is reachable over the WWAN connection")
            
        }
    }
}
