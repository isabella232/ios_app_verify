//
//  TSSuccessView.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 7/9/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

/**
    Success View shown after a successful verification.
 */
class TSSuccessView: UIView {
    
    let headerView = TSHeaderView(title: "")
    let tryAgainButton = Button(title: "Try Again?", color: .requestSMS)
    
    lazy var successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.text = "SUCCESS!"
        label.textColor = .TSGreen
        label.textAlignment = .center
        return label
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Phone Number Verified"
        label.textColor = .TSTextGray
        label.textAlignment = .center
        return label
    }()
    
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
    }
    
    private func setupSubviews() {
        
        [headerView, successLabel, titleLabel, tryAgainButton].forEach(addSubview)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        successLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 100).isActive = true
        successLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        successLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        tryAgainButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        tryAgainButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
