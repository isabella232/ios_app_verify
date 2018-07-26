//
//  Response.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/19/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation


/**
     Response base structure to capture https responses from your server.
 */
struct Response: Codable {
    let receivedOnDate: String
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case receivedOnDate = "received_on_utc"
        case code
        case message
    }
}

struct ErrorResponse: Codable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response = "status"
    }
}

/**
    Initiate response structure to capture https responses after requesting
    sms from your server.
 */
struct InitiateResponse: Codable {
    let response: Response
    
    let requestId: String
    let timeout: Int
    let maxRetries: Int
    
    enum CodingKeys: String, CodingKey {
        case response = "status"
        
        case requestId = "request_id"
        case timeout
        case maxRetries = "max_retries"
    }
}

/**
    Finalize response structure to capture https responses after sending
    verification code to your server.
 */
struct FinalizeResponse: Codable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response = "status"
    }
}
