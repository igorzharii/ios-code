struct History {
    var message: String = ""
    var time: Int = 0
    var timeAgoString: String {
        get {
            let currentTime = Int(Date().timeIntervalSince1970)
            let timePassed = currentTime - time
            
            return "\(Helpers().timeToDaysHours(remainingSeconds: Int64(timePassed))) ago"
        }
    }
    
    init(message: String, time: Int) {
        self.message = message
        self.time = time
    }
}
