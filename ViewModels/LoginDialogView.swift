import UIKit
import SwiftMessages
import FirebaseAuth

class LoginDialogView: MessageView {
    
    @IBOutlet weak var loginReasonLabel: UILabel!
    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var facebookSignInButton: UIButton!
    
    @IBAction func loginGoogle() {
        loggingIn = true
        loginIndicator.startAnimating()
        googleAction?()
    }
    
    @IBAction func loginFacebook() {
        loggingIn = true
        loginIndicator.startAnimating()
        facebookAction?()
    }
    
    var getTacosAction: ((_ count: Int) -> Void)?
    var googleAction: (() -> Void)?
    var facebookAction: (() -> Void)?
    
    var loggingIn: Bool = false {
        didSet {
            googleSignInButton.isEnabled = !self.loggingIn
            facebookSignInButton.isEnabled = !self.loggingIn
        }
    }
    
    func setup(presenter: UIViewController) {
        Loginner.shared.delegate = self
        
        loginReasonLabel.text = LocalizableStrings.loginReason.localized
        loginReasonLabel.textColor = Theme.Color.grey90
        
        googleImage.tintColor = Theme.Color.yellow80
        googleSignInButton.loginButtons()
        
        facebookImage.tintColor = Theme.Color.yellow80
        facebookSignInButton.loginButtons()
    }
}

extension LoginDialogView: LoginnerDelegate {
    
    func loginFinished(success: Bool) {
        Safe.shared.set(.loggedIn, success ? "" : nil)
        loggingIn = false
        loginIndicator.stopAnimating()
        SwiftMessages.hide()
        if success {
            let dismissClosure: () -> Void = { () in
                SwiftMessages.hide()
            }
            Alerter.shared.showLoginResult(success, success ? LocalizableStrings.loggedInSuccessfully.localized : LocalizableStrings.loggedInUnsuccessfully.localized, success ? dismissClosure : nil)
        }
    }
    
    func usernameUpdated(success: Bool) {
        Alerter.shared.showAlert(.topMessage, success, success ? LocalizableStrings.usernameUpdatedSuccessfully.localized : LocalizableStrings.usernameUpdatedUnsuccessfully.localized, nil)
    }
}
