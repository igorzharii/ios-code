import Foundation
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth

protocol LoginnerDelegate {
    
    func loginFinished(success: Bool)
    func usernameUpdated(success: Bool)
    func logout()
}

class Loginner: NSObject {
    
    static let shared = Loginner()
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    var delegate: LoginnerDelegate?
    
    func updateUsername(_ username: String) {
        var user = Safe.shared.getUser()
        user.name = username
        updateUser(user)
    }
    
    func getUser() {
        Fetcher().getUser(completion: { error, user in
            guard user != nil else {
                self.delegate?.loginFinished(success: false)
                return
            }
            if user!.name == "" {
                self.setUser(self.generateUser())
            } else {
                Safe.shared.storeUser(user!)
                self.delegate?.loginFinished(success: true)
            }
        })
    }
    
    func setUser(_ user: User) {
        Fetcher().setUser(user: user, completion: { error, success in
            if success {
                Safe.shared.storeUser(user)
                self.delegate?.loginFinished(success: true)
            } else {
                self.setUser(self.generateUser())
            }
        })
    }
    
    func updateUser(_ user: User) {
        Fetcher().setUser(user: user, completion: { error, success in
            if success {
                Safe.shared.storeUser(user)
            }
            Alerter.shared.showAlert(.topMessage, success, success ? LocalizableStrings.usernameUpdatedSuccessfully.localized : LocalizableStrings.usernameUpdatedUnsuccessfully.localized, nil)
        })
    }
    
    func generateUser() -> User {
        var name = Safe.shared.get(.userLongName).components(separatedBy: CharacterSet(charactersIn: " ")).first!.lowercased()
        for _ in 0...3 { name += String(describing: arc4random_uniform(10)) }
        var u = User()
        u.name = name
        return u
    }
    
    
    func googleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func facebookSign() {
        signInWithFacebook()
    }
    
    func googleSignIn(presenter: UIViewController) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = presenter
        GIDSignIn.sharedInstance().signIn()
    }
    
    func facebookSign(presenter: UIViewController) {
        signInWithFacebook()
    }
    
    func logout() {
        Safe.shared.removeAll()
        
        do {
            try Auth.auth().signOut()
        } catch { }
        LoginManager().logOut()
        GIDSignIn.sharedInstance()?.signOut()
        delegate?.logout()
    }
    
}

extension Loginner: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            delegate?.loginFinished(success: false)
            Alerter.shared.showLoginError(error?.localizedDescription == "The user canceled the sign-in flow." ? LocalizableStrings.loginCancelled.localized : LocalizableStrings.somethingWentWrong.localized)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        let googleUID = user.userID
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                self.delegate?.loginFinished(success: false)
                Alerter.shared.showLoginError(LocalizableStrings.somethingWentWrong.localized)
                return
            }
            
            Safe.shared.set(.userLongName, user!.user.displayName!)
            if let email = user!.user.email {
                Safe.shared.set(.userEmail, email)
            }
            Safe.shared.set(.userPhotoURL, String(describing: user!.user.photoURL!))
            Safe.shared.set(.userGoogleUID, googleUID!)
            Safe.shared.set(.firebaseUID, user!.user.uid)
            
            self.getToken()
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func signInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil, handler: { loginResult, error in
            
            if loginResult == nil && error != nil {
                self.delegate?.loginFinished(success: false)
                Alerter.shared.showLoginError(LocalizableStrings.facebookLoginFail.localized)
                return
            }
            
            if loginResult!.isCancelled {
                print("User cancelled login.")
                self.delegate?.loginFinished(success: false)
                Alerter.shared.showLoginError(LocalizableStrings.loginCancelled.localized)
                return
            }
            
            if let accessToken = AccessToken.current?.tokenString {
                print("Logged in!")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        
                        self.delegate?.loginFinished(success: false)
                        Alerter.shared.showLoginError(LocalizableStrings.somethingWentWrong.localized)
                        return
                    }
                    
                    Safe.shared.set(.userLongName, user!.user.displayName!)
                    if let email = user!.user.email {
                        Safe.shared.set(.userEmail, email)
                    }
                    
                    Safe.shared.set(.userPhotoURL, String(describing: user!.user.photoURL!))
                    Safe.shared.set(.userFBUID, AccessToken.current!.userID)
                    Safe.shared.set(.firebaseUID, user!.user.uid)
                    
                    self.getToken()
                })
            }
        })
    }
    
    func getToken() {
        Fetcher().getFirebaseToken({ _ in
            Loginner.shared.getUser()
        })
    }
}
