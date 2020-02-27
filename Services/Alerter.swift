import SwiftMessages

enum PresentationStyle {
    case topMessage
    case statusBar
}

class Alerter {
    
    static let shared = Alerter()
    
    let loginMessages = SwiftMessages()
    let alertMessages = SwiftMessages()
    
    func showLoginError(_ message: String) {
        showLoginResult(false, message, nil)
    }
    
    func showLoginResult(_ success: Bool, _ message: String, _ completion: (() -> Void)?) {
        var config = loginMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        if success {
            config.interactiveHide = false
            
            config.eventListeners.append() { event in
                if case .didHide = event {
                    if let comp = completion {
                        comp()
                    }
                }
            }
        }
        
        let view: MessageView = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(success ? .success : .error, iconStyle: .light)
        view.configureContent(title: message, body: "")
        
        view.button?.isHidden = true
        view.bodyLabel?.isHidden = true
        view.id = "LoginMessage"
        
        loginMessages.show(config: config, view: view)
    }
    
    func showLogout() {
        
        let view: MessageView = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.success, iconStyle: .light)
        view.configureContent(title: LocalizableStrings.loggedOutSuccessfully.localized, body: "")
        view.button?.isHidden = true
        view.bodyLabel?.isHidden = true
        
        loginMessages.show(view: view)
    }
    
    func showAuthDialog(controller: UIViewController, _ completion: (() -> Void)?) {
        
        let view: LoginDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.backgroundColor = Theme.Color.yellow60
        view.googleAction = { Loginner.shared.googleSignIn(presenter: controller) }
        view.facebookAction = { Loginner.shared.facebookSign(presenter: controller) }
        view.setup(presenter: controller)
        view.id = "AuthDialog"
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .viewController(controller)
        config.duration = .forever
        config.presentationStyle = .bottom
        
        config.eventListeners.append() { event in
            if case .didHide = event {
                if let comp = completion {
                    comp()
                }
            }
        }
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
        
    func showAlert(_ style: PresentationStyle, _ success: Bool, _ message: String, _ completion: (() -> Void)?) {
        var config = alertMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.interactiveHide = true
        config.eventListeners.append() { event in
            if case .didHide = event {
                if let comp = completion {
                    comp()
                }
            }
        }
        
        let layout: MessageView.Layout = style == .topMessage ? .messageView : .statusLine
        
        let view: MessageView = MessageView.viewFromNib(layout: layout)
        view.configureTheme(success ? .success : .error, iconStyle: .light)
        view.configureContent(title: style == .topMessage ? message : "", body: style != .topMessage ? message : "" )
        view.tapHandler = { _ in self.alertMessages.hide() }
        view.button?.isHidden = true
        view.id = message.removeWhiteSpace()
        
        alertMessages.show(config: config, view: view)
    }

    func showFunctionalAlert(_ parent: UIViewController, _ style: PresentationStyle, _ success: Bool, _ message: String, _ completion: (() -> Void)?) {
        var config = alertMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.interactiveHide = true
        config.eventListeners.append() { event in
            if case .didHide = event {
                if let comp = completion {
                    comp()
                }
            }
        }
        
        let layout: MessageView.Layout = style == .topMessage ? .messageView : .statusLine
        
        let view: MessageView = MessageView.viewFromNib(layout: layout)
        view.configureTheme(success ? .success : .error, iconStyle: .light)
        view.configureContent(title: style != .topMessage ? message : "", body: style == .topMessage ? message : "", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Add", buttonTapHandler: { _ in
            parent.pushListsVC()
        })
        view.tapHandler = { _ in self.alertMessages.hide() }
        view.id = message.removeWhiteSpace()
        
        alertMessages.show(config: config, view: view)
    }
}
