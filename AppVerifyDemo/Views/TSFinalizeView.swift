//
//  TSVerifyView.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/3/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

/**
    The finalize view with verification code field to be verified along with
    the confirm button.
 */
class TSFinalizeView: UIView {
    
    struct Constants {
        static let resendButtonDelay: Int = 60
    }
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(dismissKeyboard))
        return tap
    }()
    
    var phoneNumber: String? {
        didSet {
            if let number = phoneNumber {
                securityCodeTextField.title = "Enter Security Code sent to +" + number
            }
        }
    }
    
    let headerView = TSHeaderView(title: "App Verify iOS Demo")
    let securityCodeTextField = TSTextField(title: "Enter Security Code", type: .securityCode)
    let verifySecurityCodeButton = Button(title: "Confirm", color: .confirmCode)
    let resendSecurityCodeButton = Button(title: "Resend Code", color: .requestSMS)
    let cancelButton = UIButton(type: UIButtonType.system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyling()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyStyling() {
        backgroundColor = .white
        
        cancelButton.setTitle("Cancel", for: .normal)
        
        resetResendSecurityCodeButton()
    }
    
    private func setupSubviews() {
        
        [headerView, securityCodeTextField, verifySecurityCodeButton, resendSecurityCodeButton, cancelButton].forEach(addSubview)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        securityCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        securityCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        securityCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        securityCodeTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30).isActive = true
        securityCodeTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        verifySecurityCodeButton.translatesAutoresizingMaskIntoConstraints = false
        verifySecurityCodeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        verifySecurityCodeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        verifySecurityCodeButton.topAnchor.constraint(equalTo: securityCodeTextField.bottomAnchor, constant: 20).isActive = true
        verifySecurityCodeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        resendSecurityCodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendSecurityCodeButton.leadingAnchor.constraint(equalTo: verifySecurityCodeButton.leadingAnchor, constant: 40).isActive = true
        resendSecurityCodeButton.trailingAnchor.constraint(equalTo: verifySecurityCodeButton.trailingAnchor, constant: -40).isActive = true
        resendSecurityCodeButton.topAnchor.constraint(equalTo: verifySecurityCodeButton.bottomAnchor, constant: 30).isActive = true
        resendSecurityCodeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        addGestureRecognizer(tapGesture)
    }
    
    /**
        Limits requesting too many SMS requests within a short period of time
     */
    func resetResendSecurityCodeButton() {
        resendSecurityCodeButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.resendButtonDelay)) {
            self.resendSecurityCodeButton.isHidden = false
        }
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
