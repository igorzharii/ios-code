import Firebase
import FirebaseFirestore
import SwiftyJSON

enum DiffType {
    case added
    case modified
    case removed
}

class FireStoreManager {
    
    static let shared = FireStoreManager()
    
    var db: Firestore!
    let basePath = "/base/data"
    
    var roomsListener: ListenerRegistration?
    
    init() {
        let secondaryOptions = FirebaseOptions(googleAppID: "id", gcmSenderID: "id")
        secondaryOptions.bundleID = "id"
        secondaryOptions.apiKey = "key"
        secondaryOptions.clientID = "id"
        secondaryOptions.databaseURL = "url"
        secondaryOptions.storageBucket = "bucket"
        secondaryOptions.projectID = "id"

        FirebaseApp.configure(name: "primary", options: secondaryOptions)

        guard let primary = FirebaseApp.app(name: "primary")
            else { assert(false, "Could not retrieve primary app"); return }

        db = Firestore.firestore(app: primary)
    }
    
    func addRoomsListener(_ completion: @escaping (_ rooms: [Room]) -> Void) {
        roomsListener = db.collection(basePath + "/rooms")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var rooms = [Room]()
            snapshot.documentChanges.forEach { diff in
                var room = Parser().parseRoom(JSON(diff.document.data()), nil, nil)
                
                switch diff.type {
                case .modified:
                    room.diffType = .modified
                case .removed:
                    room.diffType = .removed
                case .added:
                     break
                }
                
                rooms.append(room)
                
            }
            completion(rooms)
        }
    }
}
