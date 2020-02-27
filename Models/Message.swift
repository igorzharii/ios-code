import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
    var sentDate: Date
    
    var sender: SenderType
    
    var kind: MessageKind {
        return .text(content)
    }
    
    var messageId: String
    let id: String?
    let content: String
    let sentDate: Date
    let sender: Sender
    
    var data: MessageData {
        if let image = image {
            return .photo(image)
        } else {
            return .text(content)
        }
    }

    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: MessageUser, content: String) {
        sender = Sender(id: Safe.shared.get(.firebaseUID), displayName: Safe.shared.get(.userUsername))
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: MessageUser, image: UIImage) {
        sender = Sender(id: Safe.shared.get(.firebaseUID), displayName: Safe.shared.get(.userUsername))
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        let date = data["created"] as? Timestamp
        guard let sentDate = date?.dateValue() else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }

        id = document.documentID

        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)

        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
    
}


protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
}


extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
