//
//  Service.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/5/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Service {
    static let shared = Service()
    var session: URLSession = .shared

    /**
        This method fetches the JWT authentication token. Then the JWT is used
        to call the request SMS API endpoint on your servers

        - Parameter jwtToken: Mobile authentication token
        - Parameter phoneNumber: The phone number to be verified, requires country code at the beginning
        - Parameter completion: Returns one of the following parameters depending on the outcome of the request

        - Returns:
            - **InitiateResponse:** Decodable JSON object if the request is successful
            - **errorData:** Decodable JSON object if the request is successful, but returned an error. i.e. "Invalid phone number"
            - **error:** An error object that indicates why the request failed, or nil if the request was successful
    */
    func initiate(with jwtToken: String, phoneNumber: String, completion: @escaping (InitiateResponse?, ErrorResponse?, Error?) -> ()) {
        let request = InitiateRequest(jwtToken: jwtToken, phoneNumber: phoneNumber, appendOptionalParameters: true)
        
        self.send(request: request.generateURLRequest()) { (data, response, error) in
            guard error == nil else {
                os_log("%@", log: Log.error, type: .error, (error?.localizedDescription)!)
                completion(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                os_log("Error handling initiate response", log: Log.error, type: .error)
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                os_log("Error handling initiate responseData", log: Log.error, type: .error)
                completion(nil, nil, error)
                return
            }
            
            if response.statusCode == 200 {
                if let success = request.decode(data: data) {
                    os_log("SMS Request Successful. status code: %d, message: %@", log: Log.general, type: .info, success.response.code, success.response.message)
                    completion(success, nil, nil)
                }  else {
                    os_log("Failed to Decode InitiateResponse", log: Log.error, type: .info)
                    completion(nil, nil, TSError.error(errorMessage: "Failed to Decode InitiateResponse"))
                }
            } else {
                if let error = request.decodeError(data: data) {
                    os_log("SMS Request Error. status code: %d, message: %@", log: Log.general, type: .info, error.response.code, error.response.message)
                    completion(nil, error, nil)
                } else {
                    os_log("Failed to Decode ErrorResponse", log: Log.error, type: .info)
                    completion(nil, nil, TSError.error(errorMessage: "Failed to Decode ErrorResponse"))
                }
            }
        }
    }
    
    /**
        Initiates a network request that checks if the requestId and verificationCode that are supplied match those that are temporarily stored on the Mock Server.
     
        - Parameter requestId: The requestId that was returned during a successful SMS Request
        - Parameter verificationCode: The verification code sent the the phone number provided when initiating the SMS request
        - Parameter completion: Returns one of the following parameters depending on the outcome of the request
     
        - Returns:
            - **successData:** Decodable JSON object if the request is successful
            - **errorData:** Decodable JSON object if the request is successful, but returned an error. i.e. "Verification code mismatch"
            - **error:** An error object that indicates why the request failed, or nil if the request was successful
    */
    func finalize(with requestId: String, verificationCode: String, completion: @escaping (FinalizeResponse?, ErrorResponse?, Error?) -> ()) {
        let request = FinalizeRequest(requestId: requestId, verificationCode: verificationCode)
        
        self.send(request: request.generateURLRequest()) { (data, response, error) in
            guard error == nil else {
                os_log("%@", log: Log.error, type: .error, (error?.localizedDescription)!)
                completion(nil, nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                os_log("Error handling finalize response", log: Log.error, type: .error)
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                os_log("Error handling finalize responseData", log: Log.error, type: .error)
                completion(nil, nil, error)
                return
            }
            
            if response.statusCode == 200 {
                if let success = request.decode(data: data) {
                    os_log("Finalize Request Successful. status code: %d, message: %@", log: Log.general, type: .info, success.response.code, success.response.message)
                    completion(success, nil, nil)
                } else {
                    os_log("Failed to Decode FinalizeResponse", log: Log.error, type: .info)
                    completion(nil, nil, TSError.error(errorMessage: "Failed to Decode FinalizeResponse"))
                }
            } else {
                if let error = request.decodeError(data: data) {
                    os_log("Finalize Request Error. status code: %d, message: %@", log: Log.general, type: .info, error.response.code, error.response.message)
                    completion(nil, error, nil)
                } else {
                    os_log("Failed to Decode ErrorResponse", log: Log.error, type: .info)
                    completion(nil, nil, TSError.error(errorMessage: "Failed to Decode ErrorResponse"))
                }
            }
        }
    }
   
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            completion(responseData, response, responseError)
        }
    
        task.resume()
    }
}
