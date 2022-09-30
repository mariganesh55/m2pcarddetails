//
//  M2PConstants.swift
//  Runner
//
//  Created by MARI GANESH on 05/07/22.
//

import Foundation
import KeychainAccess

/*To get DeviceId*/
var DEVICEID : String? {
    let keychain = Keychain(service: Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String  ?? "")
    if let token = keychain["deviceID"] {
        return token
    }else{
        keychain["deviceID"] = UIDevice.current.identifierForVendor?.uuidString.filter { $0 != "-" }
        let token = keychain["deviceID"]
        return token
    }
}
