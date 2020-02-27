import UIKit

open class Theme {
    open class Color {
        static let yellow80 = UIColor(hex: "ffce06")
        static let yellow60 = UIColor(hex: "ffda49")
        static let yellow5 = UIColor(hex: "f7f2dd")
        static let yellow10 = UIColor(hex: "fdf3cb")
        static let grey5 = UIColor(hex: "f7f6f6")
        static let grey50 = UIColor(hex: "c8c7cc")
        static let grey90 = UIColor(hex: "2d2d2d")
        static let grey80 = UIColor(hex: "484848")
        static let grey70 = UIColor(hex: "717070")
        static let grey60 = UIColor(hex: "c1bdb2")
        
        static let black = UIColor.black
        static let red = UIColor(hex: "bc3f3a")
        static let green = UIColor(hex: "33751f")
        static let white = UIColor(hex: "ffffff")
        static let orange = UIColor(hex: "ff5e00")
        static let transparent = UIColor.clear
        static let purple = UIColor(hex: "7400be")
        
        static let blue = UIColor(hex: "2e86c1")
        static let lightBlue = UIColor(hex: "7CC4F5")
        static let darkBlue = UIColor(hex: "1b4b64")
    }
    open class Font {
        static let size9 = UIFont.systemFont(ofSize: 9.0)
        static let size9Bold = UIFont.boldSystemFont(ofSize: 9.0)
        static let size11 = UIFont.systemFont(ofSize: 11.0)
        static let size11Bold = UIFont.boldSystemFont(ofSize: 11.0)
        static let size13 = UIFont.systemFont(ofSize: 13.0)
        static let size13Bold = UIFont.boldSystemFont(ofSize: 13.0)
        static let size14 = UIFont.systemFont(ofSize: 14.0)
        static let size14Bold = UIFont.boldSystemFont(ofSize: 14.0)
        static let size15 = UIFont.systemFont(ofSize: 15.0)
        static let size15Bold = UIFont.boldSystemFont(ofSize: 15.0)
        static let size17 = UIFont.systemFont(ofSize: 17.0)
        static let size17Bold = UIFont.boldSystemFont(ofSize: 17.0)
        static let size20 = UIFont.systemFont(ofSize: 20.0)
        static let size20Bold = UIFont.boldSystemFont(ofSize: 20.0)
        static let size22 = UIFont.systemFont(ofSize: 22.0)
        static let size22Bold = UIFont.boldSystemFont(ofSize: 22.0)
        static let size25 = UIFont.systemFont(ofSize: 25.0)
        static let size25Bold = UIFont.boldSystemFont(ofSize: 25.0)
        static let size30 = UIFont.systemFont(ofSize: 30.0)
        static let size30Bold = UIFont.boldSystemFont(ofSize: 30.0)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIButton {
    
    func round(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, tintColor: UIColor, font: UIFont, backgroundColor: UIColor, titleColor: UIColor) {
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
    }
    
    func addCorners() {
        self.round(cornerRadius: 5, borderWidth: 2, borderColor: Theme.Color.grey90, tintColor: Theme.Color.grey90, font: Theme.Font.size20Bold, backgroundColor: Theme.Color.transparent, titleColor: Theme.Color.grey90)
    }
    
    func addSmallCorners() {
        self.round(cornerRadius: 5, borderWidth: 1, borderColor: Theme.Color.grey90, tintColor: Theme.Color.grey90, font: Theme.Font.size20Bold, backgroundColor: Theme.Color.yellow80, titleColor: Theme.Color.grey90)
    }
    
    func loginButtons() {
        self.round(cornerRadius: 5, borderWidth: 1, borderColor: Theme.Color.grey90, tintColor: Theme.Color.grey90, font: Theme.Font.size15Bold, backgroundColor: Theme.Color.grey90, titleColor: Theme.Color.yellow80)
        setTitleColor(Theme.Color.yellow80, for: .selected)
    }
    
    func makeBlue() {
        self.round(cornerRadius: 5, borderWidth: 2, borderColor: Theme.Color.blue, tintColor: Theme.Color.white, font: Theme.Font.size15Bold, backgroundColor: Theme.Color.blue, titleColor: Theme.Color.yellow80)
    }
}

class VotingColor {
    
    static var shared = VotingColor()
    
    var awesomeLevel: CGFloat = 0.35
    var awesomeAdd: Bool = true
    var lameLevel: CGFloat = 0.95
    var lameAdd: Bool = true
    
    func hue(_ awesome: Bool) -> UIColor {
        if awesome {
            print (awesomeLevel)
            if awesomeLevel == 0.2 { awesomeAdd = true }
            if awesomeLevel == 0.5 { awesomeAdd = false }
            awesomeLevel = CGFloat(((awesomeLevel + 0.05 * (awesomeAdd ? 1 : -1)) * 100).rounded() / 100)
            print (awesomeLevel)
            return UIColor(hue: awesomeLevel, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        } else {
            print (lameLevel)
            if lameLevel == 0.8 { lameAdd = true }
            if lameLevel == 1.0 && lameAdd { lameLevel = 0.0 }
            if lameLevel == 0.0 && !lameAdd { lameLevel = 1.0 }
            if lameLevel == 0.1 { lameAdd = false }
            lameLevel = CGFloat(((lameLevel + 0.05 * (lameAdd ? 1 : -1)) * 100).rounded() / 100)
            print (lameLevel)
            return UIColor(hue: lameLevel, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
    }
}
