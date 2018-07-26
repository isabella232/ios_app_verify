//
//  BaseRequest.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/27/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit
import MessageUI
import Contacts
import os.log

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias HTTPHeaders = [String: String]

/**
    Request base class to generate all http request objects for use in
    communication with  your server
 
    - Parameter ResultType: Used for decoding successful responses
    - Parameter ErrorResultType: Used for decoding error responses
*/
class Request<ResultType: Decodable, ErrorResultType: Decodable> {
    var url: String
    var method: HTTPMethod = HTTPMethod.get
    var headers: HTTPHeaders?
    var body: String
        
    init(url: String, method: HTTPMethod = HTTPMethod.get, headers: HTTPHeaders? = NetworkConfiguration.shared.defaultHeaders(), body: String) {
        
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    /**
        Generates a URLRequest using the varibles supplied in the BaseRequest class.
        - Returns: URLRequest
    */
    func generateURLRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: self.url)!)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.body.data(using: .utf8)
        return request
    }
    
    public func decode(data: Data?) -> ResultType? {
        guard let data = data else {
            os_log("Data in response is nil", log: Log.error, type: .error)
            return nil
        }
        
        do {
            return try JSONDecoder().decode(ResultType.self, from: data)
        } catch let error {
            let string = String(data: data, encoding: .utf8) ?? "failed to decode response"
            os_log("Failed to decode result for %@, response: %@, error: %@", log: Log.error, type: .error, url, string, error.localizedDescription)
            return nil
        }
    }
    
    public func decodeError(data: Data?) -> ErrorResultType? {
        guard let data = data else {
            os_log("Data in response error is nil", log: Log.error, type: .error)
            return nil
        }
        
        do {
            return try JSONDecoder().decode(ErrorResultType.self, from: data)
        } catch let error {
            let string = String(data: data, encoding: .utf8) ?? "failed to decode response"
            os_log("Failed to decode error for %@, response: %@, error: %@", log: Log.error, type: .error, url, string, error.localizedDescription)
            return nil
        }
    }
}

class InitiateRequest: Request<InitiateResponse, ErrorResponse> {
    
    /**
        Creates a **SMS** request to be sent to your server which
        calls Telesign SMS API.
     
        - Parameter jwtToken: JWT Token (generated in SessionManager)
        - Parameter phoneNumber: The phone number to be verified
        - Parameter appendOptionalParameters: A Bool value for adding optional SMS request parameters
    */
    init(jwtToken: String, phoneNumber: String, appendOptionalParameters: Bool) {
        
        var body = "jwt=\(jwtToken)&phone_number=\(phoneNumber)"
        
        if appendOptionalParameters {
            let options = OptionalSMSParameters.shared.createQueryString()
            body += options
        }
        
        super.init(url: NetworkConfiguration.shared.url(with: "sms"),
                   method: .post,
                   body: body)
    }
    
    struct OptionalSMSRequestParameters {
        let smsCapable: Bool?
        let appName: String?
        let appVersion: String?
        let osName: String?
        let osVersion: String?
        let language: String?
        let requestDate: String?
        
        var dictionary: [String: String] {
            var dictionary = [String: String]()
            
            if let _ = smsCapable {
                dictionary["is_sms_capable"] = "\(smsCapable ?? true)"
            }
            
            if let _ = appName {
                dictionary["app_name"] = appName
            }
            
            if let _ = appVersion {
                dictionary["app_version"] = appVersion
            }
            
            if let _ = osName {
                dictionary["os_name"] = osName
            }
            
            if let _ = osVersion {
                dictionary["os_version"] = osVersion
            }
            
            if let _ = language {
                dictionary["language"] = language
            }
            
            if let _ =  requestDate {
                dictionary["sms_request_datetime_utc"] = requestDate
            }
            
            return dictionary
        }
    }
    
    class OptionalSMSParameters {
        static let shared = OptionalSMSParameters()
        
        /**
            Creates a dictionary of optional SMS request parameters.
         
            - Returns: A query string that can be appended to the SMS request body
        */
        func createQueryString() -> String {
            let options = OptionalSMSRequestParameters(smsCapable: checkIfSMSCapable(), appName: getAppName(), appVersion: getAppVersion(), osName: UIDevice.current.systemName, osVersion: UIDevice.current.systemVersion, language: getLocaleLanguage(), requestDate: getTimeStamp())
            
            let queryString = options.dictionary.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }).joined(separator: "&")
            
            return "&" + queryString
        }
        
        private func getAppName() -> String {
            return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        }
        
        private func getAppVersion() -> String {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        }
        
        private func getTimeStamp() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            return formatter.string(from: Date())
        }
        
        private func getLocaleLanguage() -> String {
            return Locale.preferredLanguages.first ?? ""
        }
        
        private func checkIfSMSCapable() -> Bool {
            return MFMessageComposeViewController.canSendText()
        }
    }
}

class FinalizeRequest: Request<FinalizeResponse, ErrorResponse> {
    
    /**
        Creates a **Finalize** network request to be sent to your server for
        verification of code received in the SMS payload.
     
         - Parameter requestId: The requestId that was returned during a succesful SMS request
         - Parameter verificationCode: The verification code sent the the phone number provided when initiating the SMS request
     */
    init(requestId: String, verificationCode: String) {
        super.init(url: NetworkConfiguration.shared.url(with: "code"),
                   method: .post,
                   body: "request_id=\(requestId)&verification_code=\(verificationCode)")
    }
}


