struct Helpers {
    
    func secondsToHoursMinutesSeconds (_ seconds : Int64) -> (Int, Int, Int, Int) {
        var secs = seconds
        let days = secs / (60 * 60 * 24)
        secs -= days * (60 * 60 * 24)
        let hours = secs / (60 * 60)
        secs -= hours * (60 * 60)
        let minutes = secs / 60
        secs -= minutes * 60
        return (Int(days), Int(hours), Int(minutes), Int(secs))
    }
    
    func timeToDaysHours(remainingSeconds: Int64) -> String {
        
        let (d, h, m, s) = secondsToHoursMinutesSeconds(remainingSeconds)
        
        var daysHours = "\(s)\(LocalizableStrings.secondString.localized)"
        if m > 0 {
            daysHours = "\(m)\(LocalizableStrings.minuteString.localized)"
            if s >= 30 {
                daysHours = "\(m+1)\(LocalizableStrings.minuteString.localized)"
            }
        }
        if h > 0 {
            daysHours = "\(h)\(LocalizableStrings.hourString.localized)"
            if m >= 30 {
                daysHours = "\(h+1)\(LocalizableStrings.hourString.localized)"
            }
        }
        if d > 0 {
            daysHours = "\(d)\(LocalizableStrings.dayString.localized)"
            if h >= 12 {
                daysHours = "\(d+1)\(LocalizableStrings.dayString.localized)"
            }
        }
        
        return daysHours
    }
}
