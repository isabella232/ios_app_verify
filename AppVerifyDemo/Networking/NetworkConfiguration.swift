//
//  NetworkConfiguration.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/26/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

/**
 Sets up all development endpoints that are used within the app.
 If reusing this class, make sure to switch the endpoints to the ones used within your project.
*/

enum Environment {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development: return "https://[development-hostname]/v1/appverify/"
        case .staging: return "https://[staging-hostname]/v1/appverify/"
        case .production: return "https://av-api-sample.telesign.com/v1/appverify/"
        }
    }
}

class NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    /**
     Checks the 'Configuration' key in info.plist and returns the configuration that was selected at runtime.
     Then uses the 'Configuration' value and returns the associated endpoints baseURL.
     - Attention:
       Make sure the Configurations are set within the Projects info file
    */

    var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            
            if configuration == "DEVELOPMENT" {
                return Environment.development
            } else if configuration == "STAGING" {
                return Environment.staging
            } else {
                return Environment.production
            }
        }
        
        return Environment.production
    }()
    
    func url(with path: String) -> String {
        return "\(environment.baseURL)\(path)"
    }
    
    func defaultHeaders() -> [String: String] {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
}
