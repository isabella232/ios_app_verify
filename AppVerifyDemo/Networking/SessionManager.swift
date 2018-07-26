//
//  SessionManager.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/28/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import os.log

class SessionManager {
    static let shared = SessionManager()
    
    struct Constants {
        static let customerId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    }
    
    /**
        Generates a JWT Token used for authenticating the Mock Server request.
     
        - Requires: Set constant customerId above (provided by TeleSign)
        - Throws: TSVerificationError
        - Returns: JWT Token
    */
    func generateJwtToken() throws -> String {
        
        if !Constants.customerId.isValidCustomerId() {
            throw TSError.error(errorType: .InvalidCustomerId)
        }
        
        let jwtURLString = "https://tokengen.telesign.com/v1/mobile/verification/token/" + Constants.customerId
        let jwtURL = URL(string: jwtURLString)
        do {
            let jwtData = try Data(contentsOf: jwtURL!)
            guard let jwtToken = String(data: jwtData, encoding: .ascii) else {
                os_log("Error creating jwtToken from data", log: Log.error, type: .info)
                throw TSError.error(errorType: .JWTServerConnectionFailed)
            }
            return jwtToken
            
        } catch {
            os_log("%@", log: Log.error, type: .info, error.localizedDescription)
            throw error
        }
    }
}

extension String {
    func isValidCustomerId() -> Bool {
        if UUID(uuidString: SessionManager.Constants.customerId) != nil {
            return true
        } else {
            return false
        }
    }
}
