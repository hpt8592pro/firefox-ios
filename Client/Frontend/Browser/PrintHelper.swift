/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared
import ShimWK

class PrintHelper: TabHelper {
    private weak var tab: Tab?

    class func name() -> String {
        return "PrintHelper"
    }

    required init(tab: Tab) {
        self.tab = tab
        if let path = NSBundle.mainBundle().pathForResource("PrintHelper", ofType: "js"), source = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String {
            let userScript = ShimWKUserScript(source: source, injectionTime: ShimWKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: false)
            tab.webView!.configuration.userContentController.addUserScript(userScript)
        }
    }

    func scriptMessageHandlerName() -> String? {
        return "printHandler"
    }

    func userContentController(userContentController: ShimWKUserContentController, didReceiveScriptMessage message: ShimWKScriptMessage) {
        if let tab = tab, webView = tab.webView {
            let printController = UIPrintInteractionController.sharedPrintController()
            printController.printFormatter = webView.view.viewPrintFormatter()
            printController.presentAnimated(true, completionHandler: nil)
        }
    }
}
