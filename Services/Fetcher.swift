import Alamofire
import SwiftyJSON
import FirebaseAuth

class Fetcher: NSObject {
    
    static var shared = Fetcher().generateSharedManager()
    
    func updateSharedManager() {
        Fetcher.shared = Fetcher().generateSharedManager()
    }
    
    func generateSharedManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept": "application/json",
                                               "Content-Type": "application/json",
                                               "User-Agent": "iTunes"]
        
        let manager: SessionManager = SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)

        return manager
    }
    
    func getUser(completion: @escaping (_ error: String?, _ result: User?) -> Void) {
        
        Fetcher.shared.request(Router.getUserData).debugLog().responseJSON { response in
            
            switch response.result {
            case let .success(value):
                completion(nil, Parser().parseUser(JSON(value as Any)["data"]["info"]))
            case let .failure(error):
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    func artwork(artist: String, title: String, completion: @escaping (_ error: String?, _ result: String) -> Void) {
        Fetcher.shared.request(Router.artwork(artist: artist, title: title)).debugLog().responseJSON { response in
        
            switch response.result {
            case let .success(value):
                completion(nil, JSON(value as Any)["result"][0]["arturl"].stringValue)
            case let .failure(error):
                completion(error.localizedDescription, "")
            }
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}
