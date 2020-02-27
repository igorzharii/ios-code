import KeychainAccess

enum SafeKind: String, CaseIterable {
    case firebaseToken
    case firebaseUID
    
    case userEmail
    case userLongName
    case userFBUID
    case userGoogleUID
    case userPhotoURL
    case userUsername
    
    case countryCode
    case loggedIn
    case lists
    case firstStart
}

class Safe {
    
    static let shared = Safe()
    let defaults = UserDefaults.standard
    let keychain = Keychain(service: Constants.bundleName)
    
    var loggedIn: Bool { return keychain[SafeKind.loggedIn.rawValue] != nil }
    var firstStart: Bool { return keychain[SafeKind.firstStart.rawValue] == nil }
    
    func set(_ key: SafeKind, _ value: String?) {
        keychain[key.rawValue] = value
    }
    
    func get(_ key: SafeKind) -> String {
        return keychain[key.rawValue] ?? ""
    }
    
    func storeUser(_ user: User) {
        set(.userUsername, user.name)
        set(.userBodyType, String(user.bodyType))
    }
    
    func getUser() -> User {
        var user = User()
        user.name = get(.userUsername)
        user.bodyType = Int(get(.userBodyType)) ?? 0
        
        return user
    }
    
    func removeAll() {
        SafeKind.allCases.forEach({
            keychain[$0.rawValue] = nil
            defaults.removeObject(forKey: $0.rawValue)
        })
        defaults.synchronize()
        
        doFirstStart()
    }
    
    func doFirstStart() {
        guard firstStart else { return }
        
        Safe.shared.set(.firebaseUID, NSUUID().uuidString)
        Safe.shared.set(.firstStart, "")
    }
    
    func getUD<T>(_ key: SafeKind) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }

    func setUD<T>(_ key: SafeKind, _ value: T) {
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
}
