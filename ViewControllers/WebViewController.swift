import UIKit
import SafariServices
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView!
    var webLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let escapedString = webLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: Constants.bounds.size.width, height: Constants.bounds.size.height)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: frame, configuration: webConfiguration)
        view.addSubview(webView)
        
        webView.load(URLRequest(url: URL(string: escapedString!)!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

}
