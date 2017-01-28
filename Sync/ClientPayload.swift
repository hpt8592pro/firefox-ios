/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared

open class ClientPayload: CleartextPayloadJSON {
    override open func isValid() -> Bool {
        if !super.isValid() {
            return false
        }

        if self["deleted"].bool ?? false {
            return true
        }

        return self["name"].isString &&
               self["type"].isString
    }

    var commands: [JSON] {
        return self["commands"].asArray ?? []   // It might not be present at all.
    }

    var name: String {
        return self["name"].string!
    }

    var clientType: String {
        return self["type"].string!
    }
    
    override open func equalPayloads(_ obj: CleartextPayloadJSON) -> Bool {
        if !(obj is ClientPayload) {
            return false
        }

        if !super.equalPayloads(obj) {
            return false
        }

        let p = obj as! ClientPayload
        if p.name != self.name {
            return false
        }
        
        if p.clientType != self.clientType {
            return false
        }

        return true
    }

    // TODO: version, protocols.
}
