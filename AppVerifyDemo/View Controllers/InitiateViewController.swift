//
//  InitiateViewController.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/18/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit
import os.log


/**
    This view controller is for picking your country code and phone number
    to be verified. It binds functionality from various helpers and views to
    accumulate the data required to proceed with verification.
 */
class InitiateViewController: ViewController {

    let initiateView = TSInitiateView()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(initiateView)
        setupInitiateView()
        view.bringSubview(toFront: activityIndicator)
    }

    func setupInitiateView() {
        initiateView.translatesAutoresizingMaskIntoConstraints = false
        initiateView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        initiateView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        initiateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        initiateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        initiateView.verifyButton.addTarget(self, action: #selector(verifyButtonPressed), for: .touchUpInside)
        
        initiateView.countryCodeTapGesture.addTarget(self, action: #selector(presentCountryCodeTableView))
        initiateView.phoneTextField.textField.becomeFirstResponder()
    }
    
    @objc func verifyButtonPressed() {
        activityIndicator.startAnimating()
        
        guard let countryCode = initiateView.phoneTextField.countryCodeTextField.text else { return }
        guard let phoneNumber = initiateView.phoneTextField.textField.text else { return }
        
        if phoneNumber.isEmpty {
            Alert.displayMissingPhoneNumberError(on: self)
            return
        } else {
            let sanitizedNumber = initiateView.phoneTextField.sanitizePhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber)
            requestSMS(with: sanitizedNumber)
        }
    }
    
    func requestSMS(with phoneNumber: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let jwtToken = try SessionManager.shared.generateJwtToken()
                Service.shared.initiate(with: jwtToken, phoneNumber: phoneNumber) { (successData, errorData, error) in
                    guard error == nil else {
                        if let error = error as? TSError {
                            Alert.displayError(on: self, with: "Error", message: error.errorMessage)
                        } else {
                            Alert.displayError(on: self, with: "Error", message: (error?.localizedDescription)!)
                        }
                        return
                    }
                    
                    if successData != nil {
                        guard let data = successData else { return }
                        self.presentVerifyController(requestId: data.requestId, phoneNumber: phoneNumber, timeout: data.timeout)
                        
                    } else {
                        guard let data = errorData else { return }
                        Alert.displayError(on: self, with: "Error", message: data.response.message)
                    }
                }
            } catch {
                if let error = error as? TSError {
                    os_log("%@", log: Log.error, type: .error, error.errorMessage)
                    Alert.displayError(on: self, with: "Error", message: error.errorMessage)
                } else {
                    os_log("%@", log: Log.error, type: .error, error.localizedDescription)
                    Alert.displayError(on: self, with: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    func presentVerifyController(requestId: String, phoneNumber: String, timeout: Int) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            let finalizeViewController = FinalizeViewController(requestId: requestId, phoneNumber: phoneNumber, timeout: timeout)
            let navController = UINavigationController(rootViewController: finalizeViewController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc func presentCountryCodeTableView() {
        let viewController = CountryCodeViewController()
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension InitiateViewController: CountryCodeViewDelegate {
    func didSelectCountryCode(code: String) {
        initiateView.phoneTextField.countryCode = code
    }
}

