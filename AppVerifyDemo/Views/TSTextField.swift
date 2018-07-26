//
//  TSTextField.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/18/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

enum TextFieldType {
    case phoneNumber
    case securityCode
}

/**
    Textfield view used to present the vountry code and phone number fields.
 */
class TSTextField: UIView, UITextFieldDelegate {
    
    struct Constants {
        static let textFieldFontSize: CGFloat = 24
        static let textFieldHeight: CGFloat = 40
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var countryCode: String? {
        didSet {
            countryCodeTextField.text = countryCode
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .TSTextGray
        return label
    }()
    
    lazy var countryCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: Constants.textFieldFontSize, weight: .medium)
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: Constants.textFieldFontSize, weight: .medium)
        return textField
    }()
    
    lazy var countryCodeUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .TSBlue
        return view
    }()
    
    lazy var textUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .TSBlue
        return view
    }()
    
    var textFieldType: TextFieldType = .phoneNumber
    
    init(title: String, type: TextFieldType) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        textFieldType = type

        applyStyling()
        setupSubviews()
    }
    
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
        
        switch textFieldType {
        case .phoneNumber:
            textField.textContentType = .telephoneNumber
            textField.keyboardType = .phonePad
            textField.textAlignment = .left
        case .securityCode:
            textField.keyboardType = .namePhonePad
            textField.returnKeyType = .done
            textField.textAlignment = .center
        }
        
        textField.delegate = self
    }
    
    private func setupSubviews() {
        [titleLabel, textField, textUnderline].forEach(self.addSubview)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true

        switch textFieldType {
        case .phoneNumber:
            [countryCodeTextField, countryCodeUnderline].forEach(self.addSubview)
            
            countryCodeTextField.translatesAutoresizingMaskIntoConstraints = false
            countryCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            countryCodeTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            countryCodeTextField.widthAnchor.constraint(equalToConstant: 75).isActive = true
            countryCodeTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
            
            countryCodeUnderline.translatesAutoresizingMaskIntoConstraints = false
            countryCodeUnderline.leadingAnchor.constraint(equalTo: countryCodeTextField.leadingAnchor).isActive = true
            countryCodeUnderline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            countryCodeUnderline.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
            countryCodeUnderline.widthAnchor.constraint(equalTo: countryCodeTextField.widthAnchor).isActive = true
            
            textField.leadingAnchor.constraint(equalTo: countryCodeTextField.trailingAnchor, constant: 8).isActive = true
        case .securityCode:
            textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        }

        textUnderline.translatesAutoresizingMaskIntoConstraints = false
        textUnderline.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        textUnderline.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textUnderline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textUnderline.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
    }
    
    /**
        Removes all non-numeric characters from the country code and phone number, then checks to see if the phone number already contains the country code. If it does, then just the sanitize phone number will be returned. If it does not, the sanitized country code and phone number are combined, then returned.
 
        - Parameter countryCode: Country Code that was selected
        - Parameter phoneNumber: Phone Number that was entered
     
        - Returns: String
    */
    func sanitizePhoneNumber(countryCode: String, phoneNumber: String) -> String {
        
        let sanitizedCountryCode = sanitizeString(string: countryCode)
        let sanitizedPhoneNumber = sanitizeString(string: phoneNumber)
        
        if sanitizedPhoneNumber.prefix(sanitizedCountryCode.count) == sanitizedCountryCode {
            return sanitizedPhoneNumber
        } else {
            return sanitizedCountryCode + sanitizedPhoneNumber
        }
    }
    
    /**
        Takes a phone number as String and removes all non numeric characters
        from it before returning.
     */
    func sanitizeString(string: String) -> String {
        return String(string.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
