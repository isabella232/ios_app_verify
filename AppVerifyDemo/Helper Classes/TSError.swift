//
//  TSError.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/25/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation

public class TSError: Error {
    
    
    public var errorTitle: String
    public var errorMessage: String

    public var fullDescription: [String: Any] {
        return ["title" : errorTitle,
                "message" : errorMessage]
    }
    
    public enum ErrorType: String {
        case Unknown = "Unknown"
        
        /**
            The JWT Auth token URL configured in the app failed to respond.
            Check internet connectivity since this is the first http request
            in verification process.
         */
        case JWTServerConnectionFailed = "JWT Server Connection Failed"
        
        /**
            Could not connect to the our servers. Check the request structure.
         */
        case ServerConnectionFailed = "Server Connection Failed"
        
        /**
            Received an unrecognizable response from the server. This can
            happen if there is a problem with the server or if the request is
            malformed.
         */
        case ServerBadResponse = "Server Bad Response"
        
        /**
            The trial auth token URL set in the sample app needs a valid
            Telesign customer ID to be setup.
         */
        case InvalidCustomerId = "Invalid Customer Id for JWT"
    }
    
    public init(errorTitle: String, errorMessage: String) {
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
    }
    
    /// For custom error with message
    static func error(errorMessage: String) -> TSError {
        return TSError(errorTitle: "Error", errorMessage: errorMessage)
    }
    
    static func error(errorType: ErrorType) -> TSError {
        return TSError(errorTitle: "Error", errorMessage: errorType.rawValue)
    }
}
