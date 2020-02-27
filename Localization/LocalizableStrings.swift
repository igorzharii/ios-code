enum LocalizableStrings: String {
    
    // MARK: Global
    case appName = "app_name"
    case ok = "ok"
    case no = "no"
    case cancel = "cancel"
    case dayString = "day_string"
    
    
    // MARK: Room list screen
    case createRoom = "create_room"
    
    
    // MARK: Room details screen
    case history = "history"
    
    
    // MARK: List screen
    case lists = "lists"
    
    
    // MARK: Playlist screen
    case added = "added"
    
    
    // MARK: Create room screen
    case couldntCreate = "couldnt_create"
    case createdSuccessfully = "created_successfully"
    
    
    // MARK: Auth screen
    case loginReason = "login_reason"
    case loggedIn = "logged_in"
    
    
    // MARK: Alerts
    case loggingIn = "logging_in"
    case somethingWentWrong = "something_went_wrong"
    
    
    //MARK: Internet Connection
    case pleaseCheckYourConnection = "please_check_your_connection"
    
    
    // MARK: Function
    var localized: String {
        return self.rawValue.localized()
    }
}


extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable-en", value: "**\(self)**", comment: "")
    }
}
