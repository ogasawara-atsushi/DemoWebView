
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openUIWebViewDidTapped(_ sender: Any) {
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UIWebViewControllerID")
        present(nextView, animated: true, completion: nil)
    }

    @IBAction func openWKWebViewDidTapped(_ sender: Any) {
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WKWebViewControllerID")
        present(nextView, animated: true, completion: nil)
    }

    @IBAction func clearCookieDidTapped(_ sender: Any) {
        CookieManager.clearCookieStroage()
        CookieManager.clearWKWebViewCookies()
    }
}
