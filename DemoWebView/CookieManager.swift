import Foundation
import WebKit

class CookieManager {

    static func clearCookieStroage() {
        URLSession.shared.reset {}
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                NSLog("cookie name = %@", cookie.name)
                HTTPCookieStorage.shared.deleteCookie(cookie)
                // Cookie上書きでは消せなかった
                // CookieManager.replaceCookie(from: cookie)
            }
        }
    }

    static func replaceCookie(from cookie: HTTPCookie) {
        let cookieProps: [HTTPCookiePropertyKey : Any] = [
            HTTPCookiePropertyKey.domain: cookie.domain,
            HTTPCookiePropertyKey.path: cookie.path,
            HTTPCookiePropertyKey.name: cookie.name,
            HTTPCookiePropertyKey.value: "",
            HTTPCookiePropertyKey.secure: cookie.isSecure,
            HTTPCookiePropertyKey.expires: cookie.name
        ]
        let newCookie = HTTPCookie(properties: cookieProps)
        HTTPCookieStorage.shared.setCookie(newCookie!)
    }

    static func clearWKWebViewCookies() {
        let deleteDataTypes:Set<String> = [WKWebsiteDataTypeCookies]

        URLSession.shared.reset {}

        // この処理を入れると正常にCookieを削除できた
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            var clearTargetRecords:[WKWebsiteDataRecord] = []

            for record in records {
                for deleteDataType in deleteDataTypes {
                    if record.dataTypes.contains(deleteDataType) {
                        clearTargetRecords.append(record)
                        break
                    }
                }
            }

            if !clearTargetRecords.isEmpty {
                NSLog("clearTargetRecords = %@", clearTargetRecords)
                dataStore.removeData(ofTypes: deleteDataTypes, for: clearTargetRecords, completionHandler: {})
            }
//            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})

            UserDefaults.standard.synchronize() // おまじない
        }

        // これだけでは消えなかった
        if #available(iOS 11.0, *) {
            dataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
//                    NSLog("cookie name = %@", cookie.name)
                    dataStore.httpCookieStore.delete(cookie)
                }
            }
        }
    }
}
