//
//  TSHeaderView.swift
//  AppVerifyDemo
//
//  Created by Chad Timmerman on 6/18/18.
//  Copyright © 2018 TeleSign. All rights reserved.
//

import UIKit

/**
    A consistent header view with logo and title for the sample app.
 */
class TSHeaderView: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .TSTextGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "telesign_logo")
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title

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
    }
    
    private func setupSubviews() {
        [logoImageView, titleLabel].forEach(self.addSubview)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
}
