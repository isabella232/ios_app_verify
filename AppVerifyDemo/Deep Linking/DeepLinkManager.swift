//
//  DeepLinkManager.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/25/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation

enum DeepLinkType {
    case verify
}

let DeepLinker = DeepLinkManager()

/**
    Deep link setup sent in SMS payload for verification.
    Deep link example: [URI]://[hostname]?verificationCode
 
    - Attention:
        - Link URI can be set in the plist
        - appVerifyHost Deep link host name to be verified while parsing for OTP code.
 */
class DeepLinkManager {
    fileprivate init() { }
    
    private var deeplinkType: DeepLinkType?
    var appVerifyHost = "verify"
    
    @discardableResult
    func handleDeepLink(url: URL) -> Bool {
        deeplinkType = DeepLinkParser.shared.parseDeepLink(url)
        return deeplinkType != nil
    }
}
