//
//  Alert.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/16/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

struct Alert {
    
    static func displayError(on viewController: ViewController, with title: String, message: String, dismissController: Bool = false) {
        
        DispatchQueue.main.async {
            viewController.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: { _ in
                if dismissController {
                    viewController.dismiss(animated: true, completion: nil)
                }
            })
            
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func displayMissingPhoneNumberError(on viewController: ViewController) {
        displayError(on: viewController, with: "Error", message: "Please enter a valid phone number")
    }
    
    static func displayMissingVerificationCodeError(on viewController: ViewController) {
        displayError(on: viewController, with: "Error", message: "Please enter the verification code")
    }
    
    static func displayTimeoutError(on viewController: ViewController) {
        displayError(on: viewController, with: "Error", message: "Verification timed out, please retry verification", dismissController: true)
    }
    
    static func displayDeeplinkError(on viewController: ViewController) {
        displayError(on: viewController, with: "Error", message: "AppVerify link could not be handled, please retry verification", dismissController: true)
    }
}


