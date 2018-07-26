//
//  FinalizeViewController.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/20/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit
import os.log

/**
    This View Controller handles the verification code received in the SMS
    payload as manual entry or using the app deep link provided to finalize the
    verification with your server.
 */
class FinalizeViewController: ViewController {

    var requestId: String = ""
    var phoneNumber: String = ""
    var timeout: Int
    
    var countdownTimer = Timer()
   
    let finalizeView = TSFinalizeView()
    
    init(requestId: String, phoneNumber: String, timeout: Int) {
        self.requestId = requestId
        self.phoneNumber = phoneNumber
        self.timeout = timeout
        self.finalizeView.phoneNumber = phoneNumber
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        os_log("Deinit Finalize View Controller", log: Log.general, type: .info)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        finalizeView.securityCodeTextField.textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(finalizeView)
        setupFinalizeView()
        startCountdownTimer()
    }
    
    func setupFinalizeView() {
        finalizeView.translatesAutoresizingMaskIntoConstraints = false
        finalizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        finalizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        finalizeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        finalizeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        finalizeView.verifySecurityCodeButton.addTarget(self, action: #selector(verifyButtonPressed), for: .touchUpInside)
        finalizeView.resendSecurityCodeButton.addTarget(self, action: #selector(resendSecurityCode), for: .touchUpInside)
        finalizeView.cancelButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    @objc func dismissViewController() {
        countdownTimer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func verifyButtonPressed() {
        self.finalizeView.securityCodeTextField.textField.resignFirstResponder()
        
        guard let verificationCode = finalizeView.securityCodeTextField.textField.text else {
            return
        }
        
        if verificationCode.isEmpty {
            Alert.displayMissingVerificationCodeError(on: self)
            return
        } else {
            self.verify(with: verificationCode)
        }
    }
    
    @objc func resendSecurityCode() {
        activityIndicator.startAnimating()
        
        finalizeView.resetResendSecurityCodeButton()

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let jwtToken = try SessionManager.shared.generateJwtToken()
                Service.shared.initiate(with: jwtToken, phoneNumber: self.phoneNumber) { (successData, errorData, error) in
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
                        self.updateValues(with: data.requestId, timeout: data.timeout)
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
    
    func verify(with verificationCode: String) {
        activityIndicator.startAnimating()

        DispatchQueue.global(qos: .userInitiated).async {
            Service.shared.finalize(with: self.requestId, verificationCode: verificationCode) { (successData, errorData, error) in
                guard error == nil else {
                    if let error = error as? TSError {
                        Alert.displayError(on: self, with: "Error", message: error.errorMessage)
                    } else {
                        Alert.displayError(on: self, with: "Error", message: (error?.localizedDescription)!)
                    }
                    return
                }
                
                if successData != nil {
                    guard successData != nil else { return }
                    self.success()
                } else {
                    guard let data = errorData else { return }
                    if data.response.code == ServerError.invalidCode.rawValue {
                        Alert.displayError(on: self, with: "Error", message: data.response.message)
                    } else {
                        Alert.displayError(on: self, with: "Error", message: data.response.message, dismissController: true)
                    }
                }
            }
        }
    }
    
    func updateValues(with requestId: String, timeout: Int) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.requestId = requestId
            self.timeout = timeout
        }
    }
    
    func success() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.countdownTimer.invalidate()
            self.navigationController?.pushViewController(SuccessViewController(), animated: false)
        }
    }
    
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if timeout != 0 {
            timeout -= 1
        } else {
            Alert.displayTimeoutError(on: self)
            countdownTimer.invalidate()
        }
    }
}

enum ServerError: Int {
    case invalidCode = 1008
}
