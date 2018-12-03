import Foundation
import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var baseView: UIView!

    var request = URLRequest(url: URL(string: "")!)
    var webView: WKWebView!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpWebView()
        baseView.addSubview(webView)
        self.loadURL()
    }

    // MARK: Private Method

    private func setUpWebView() {
        let userContentController = WKUserContentController()
        let script = WKUserScript(source: cookieScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(script)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        webView.navigationDelegate = self
    }

    private func loadURL() {
        request.setValue(cookies.joined(separator: ";"), forHTTPHeaderField: "Cookie")
        webView.load(request)
    }

    private var cookies: [String] {
        var dic = [String: String]()
        dic["WKWEBVIEW-HOGE1"] = "hoge1"
        dic["WKWEBVIEW-HOGE2"] = "hoge2"
        return dic.map { "\($0)=\($1)" }
    }

    private var cookieScript: String {
        return cookies.map { "document.cookie='\($0);\(cookieAttributes())';" }.joined()
    }

    private func cookieAttributes() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")
        let expireDate = Date(timeIntervalSinceNow: (60 * 60 * 24 * 30))
        let expireString = formatter.string(from: expireDate)
        return "expires=\"\(expireString)\"; path=/);"
    }

    // MARK: WKNavigationDelegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("navigationAction Request = \(navigationAction.request)")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // 連続した通信の最後に呼ばれる。そのため、リダイレクト発生時の302=>302=>200のようなケースは最後の200のときに呼ばれる
        print("navigationResponse Response = \(navigationResponse.response)")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // RedirectにSet-Cookieがついている場合、リダイレクト先のリクエスト時には反映されず、初回Request、WKWebViewConfigurationにセットしたCookieしか乗らない
        print("didStartProvisionalNavigation")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // リダイレクトが発生するたびに呼ばれるが、このタイミングではResponseは取得できない
        print("didReceiveServerRedirectForProvisionalNavigation = \(webView.url)")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }

    // MARK: Action

    @IBAction func closeButtonDiDTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goBackDidTapped(_ sender: Any) {
        webView.goBack()
    }
}
