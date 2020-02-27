
import Alamofire

enum Router: URLRequestConvertible {
    case getRoom(roomId: String)
    case createRoom(room: Room)
    
    static let urlString = "https://url.com/api/v1"

    var method: HTTPMethod {
        switch self {
        case .getRoom:
            return .get
        case .createRoom:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getRooms:
            return "/rooms"
        case .createRoom:
            return "/room"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getRoom(let roomId):
            return ["room_id" : roomId]
        case .createRoom(let room):
            return ["name" : room.name,
                    "genre" : room.genre,
                    "creator" : room.creator,
                    "password" : room.password,
                    "expiryDate" : room.expiryDate]
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        var url: URL
        var params = [String : Any]()
        var urlRequest: URLRequest
        
        switch self {
            
        // Unauthorized GET requests
        case .getRooms:
            url = try Router.urlString.asURL()
            urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            parameters?.forEach { params[$0] = $1 }
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            return urlRequest
            
        // Authorized POST requests
        case .createRoom:
            url = try Router.urlString.asURL()
            urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            params["id"] = Safe.shared.get(.firebaseToken)
            parameters?.forEach { params[$0] = $1 }
            
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            
            urlRequest.httpBody = jsonData
            return urlRequest
        }
    }
}
