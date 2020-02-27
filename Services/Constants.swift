import UIKit

struct Constants {
    
    // Global
    static let bounds = UIScreen.main.bounds
    static let bundleName = "name"
    static let appName = "name"
    
    
    // Analytics
    static let aOpenedApp = "opened_app"

    
    // Alert ids
    static let loggingInInfo = "LoggingInInfo"
    static let loggedInInfo = "LoggedInInfo"
    
    
    // View controllers
    static let roomsViewController = "RoomsViewController"
    static let webViewController = "WebViewController"
    
    
    // Helpers
    func initiateVCFromMainStoryboard(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: name)
    }
    
    func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
