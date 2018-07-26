//
//  TSInitiateView.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/3/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit
import os.log

/**
     The initiate view with country code and phone number field to be verified
     along with the verify button.
 */
class TSInitiateView: UIView {
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(dismissKeyboard))
        return tap
    }()
    
    lazy var countryCodeTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    let headerView = TSHeaderView(title: "App Verify iOS Demo")
    let verifyButton = Button(title: "Verify", color: .requestSMS)
    let phoneTextField = TSTextField(title: "Select Country Code and Enter Phone Number", type: .phoneNumber)
    
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
        phoneTextField.countryCodeTextField.text = suggestedCountryCode()
        phoneTextField.countryCodeTextField.addGestureRecognizer(countryCodeTapGesture)
    }
    
    private func setupSubviews() {
        
        [headerView, phoneTextField, verifyButton].forEach(addSubview)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        verifyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        verifyButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        bringSubview(toFront: headerView)
        addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    /**
        Attempts to get the local country code (ex. "US") by accessing the user's region settings. Then searches the countryCodesArray that is created from the countryCode.json file for the corresponding dial code and returns that value. Defaults to "+1" if no dial code or local country code is found.
     
        - Returns: Suggested country code
    */
    func suggestedCountryCode() -> String {
        
        var countryDialCode = "+1"
        
        if let isoCountryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {

            var countryCodesArray = [CountryCodeInfo]()
            
            guard let path = Bundle.main.path(forResource: "countryCode", ofType: "json") else { return countryDialCode }
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                countryCodesArray = try JSONDecoder().decode([CountryCodeInfo].self, from: data)
            } catch let error {
                os_log("Failed to decode result for %@", log: Log.error, type: .error, error.localizedDescription)
            }
            
            for countryCodeInfo in countryCodesArray {
                if countryCodeInfo.code == isoCountryCode {
                    countryDialCode = countryCodeInfo.dialCode
                }
            }
            
            return countryDialCode
        } else {
            return countryDialCode
        }
    }
}
