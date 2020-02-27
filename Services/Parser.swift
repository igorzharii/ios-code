import Foundation
import SwiftyJSON

struct Parser {

    func parseUsers(_ users: JSON) -> [User] {
        var parsedUsers = [User]()
        
        for (_, user):(String, JSON) in users {
            parsedUsers.append(parseUser(user))
        }
        
        return parsedUsers
    }

    func parseUser(_ user: JSON) -> User {
        var u = User()
        u.id = user["id"].stringValue
        u.name = user["username"].stringValue
        u.points = user["points"].intValue
        u.playing = user["playing"].boolValue != false
        
        return u
    }

}
