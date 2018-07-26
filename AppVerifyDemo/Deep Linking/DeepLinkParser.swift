//
//  DeepLinkParser.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/22/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import UIKit

class DeepLinkParser {
    static let shared = DeepLinkParser()
    
    private init() { }
    
    func parseDeepLink(_ url: URL) -> DeepLinkType? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return nil
        }
        
        if host == DeepLinker.appVerifyHost {
            if let code = components.query {
                if let topController = UIApplication.topViewController() as? FinalizeViewController {
                    topController.verify(with: code)
                    return DeepLinkType.verify
                } else if let controller = UIApplication.topViewController() as? ViewController {
                    Alert.displayDeeplinkError(on: controller)
                }
            }
        }
        
        return nil
    }    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
