/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared
import ShimWK

protocol FindInPageHelperDelegate: class {
    func findInPageHelper(findInPageHelper: FindInPageHelper, didUpdateCurrentResult currentResult: Int)
    func findInPageHelper(findInPageHelper: FindInPageHelper, didUpdateTotalResults totalResults: Int)
}

class FindInPageHelper: TabHelper {
    weak var delegate: FindInPageHelperDelegate?
    private weak var tab: Tab?

    class func name() -> String {
        return "FindInPage"
    }

    required init(tab: Tab) {
        self.tab = tab

        if let path = NSBundle.mainBundle().pathForResource("FindInPage", ofType: "js"), source = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String {
            let userScript = ShimWKUserScript(source: source, injectionTime: ShimWKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
            tab.webView!.configuration.userContentController.addUserScript(userScript)
        }
    }

    func scriptMessageHandlerName() -> String? {
        return "findInPageHandler"
    }

    func userContentController(userContentController: ShimWKUserContentController, didReceiveScriptMessage message: ShimWKScriptMessage) {
        let data = message.body as! [String: Int]

        if let currentResult = data["currentResult"] {
            delegate?.findInPageHelper(self, didUpdateCurrentResult: currentResult)
        }

        if let totalResults = data["totalResults"] {
            delegate?.findInPageHelper(self, didUpdateTotalResults: totalResults)
        }
    }
}
