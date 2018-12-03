import UIKit

class UIWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    let url = URL(string: "")!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpWebView()
        self.loadURL()
    }

    // MARK: Private Method

    private func setUpWebView() {
        self.webView.stringByEvaluatingJavaScript(from: buildUICookieScript())
    }

    private func loadURL() {
        var request = URLRequest(url: url)

        var cookieProperties = [HTTPCookiePropertyKey: Any]()
        cookieProperties = [HTTPCookiePropertyKey: Any]()
        cookieProperties[.name] = "UIWEBVIEW-HOGE1"
        cookieProperties[.value] = "hoge1"
        cookieProperties[.path] = "/"
        cookieProperties[.expires] = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        if let cookie = HTTPCookie(properties: cookieProperties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }

        cookieProperties = [HTTPCookiePropertyKey: Any]()
        cookieProperties[.name] = "UIWEBVIEW-HOGE2"
        cookieProperties[.value] = "hoge1¥2"
        cookieProperties[.path] = "/"
        cookieProperties[.expires] = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30)
        if let cookie = HTTPCookie(properties: cookieProperties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }

        request.addValue("UIWEBVIEW-HOGE1=hoge1;UIWEBVIEW-HOGE2=hoge2;", forHTTPHeaderField: "Cookie")

        self.webView.loadRequest(request)
    }

    private func buildUICookieScript() -> String {
        var script = String()

        script.append("document.cookie='")
        script.append("UIWEBVIEW-HOGE1=hoge1; ")
        script = addCookieCommonProperties(script)

        script.append("UIWEBVIEW-HOGE2=hoge2; ")
        script = addCookieCommonProperties(script)
        script.append("'")

        return script
    }

    private func addCookieCommonProperties(_ script: String?) -> String {
        guard var script = script else {
            return String()
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")
        let expireDate = Date(timeIntervalSinceNow: (60.0 * 60.0 * 24.0 * 30.0))
        let expireString = formatter.string(from: expireDate)

        script.append("expires=\"\(expireString)\"; path=/);")

        return script
    }

    // MARK: Action
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
